#include "annmex.h"
#include <string.h>

/* 
 * ann operations:
 *  open            ann = annmex(OPEN, pts)
 *  close           [ann] = annmex(CLOSE, ann)
 *  k-search        [idx dst] = annmex(KSEARCH, ann, query, k, eps)
 *  Pri-search      [idx dst] = annmex(PRISEARCH, ann, query, k, eps)
 *  FR-search       [idx dst inr] = annmex(FRSEARCH, ann, query, k, eps, r) r is _not_ squared here !
 *
 */
template<class T>
T min(T i1, T i2)
{
    return (i1 < i2) ? i1 : i2;
}
template<class T>
void GetArrSq(const mxArray* x, T* arr);

/* entrance point for mex file */
void mexFunction(
	int nlhs,              // Number of left hand side (output) arguments
	mxArray *plhs[],       // Array of left hand side arguments
	int nrhs,              // Number of right hand side (input) arguments
	const mxArray *prhs[]  // Array of right hand side arguments
				)
{
    /* no inputs - one output : give data regarding the class */
    if ( nlhs == 1 && nrhs == 0 ) {
        plhs[0] = mxCreateNumericMatrix(1, 1, mxCOORD_CLASS, mxREAL);
        ANNcoord * tmp = (ANNcoord*)mxGetData(plhs[0]);
        *tmp = 0;
        return;
    }

    /* regular modes */
    if ( nrhs < 2 ) 
        mexErrMsgIdAndTxt("annmex:inputs","too few input arguments");
        
    /* first argument - mode of operation */
    ann_mex_mode_t mode;
    int tmpi(0);
    int * iptr = NULL;
    GetScalar(prhs[0], tmpi);
    mode = (ann_mex_mode_t)tmpi;
    
    /* special treatment for opening */
    if ( mode == OPEN ) {
        if ( nlhs != 1 )
            mexErrMsgIdAndTxt("annmex:open","wrong number of outputs - must be one");
        
        ann_mex_t * annp = new ann_mex_t(prhs[1]);
        /* convert the pointer and return it as pointer_type */
        plhs[0] = mxCreateNumericMatrix(1, 1, mxPOINTER_CLASS, mxREAL);
        pointer_t * ptr = (pointer_t*)mxGetData(plhs[0]);
        *ptr = (pointer_t)annp;
        return;
    }
    /* for all pther modes - second argument is the ann_mex_t pointer */
    /* extract pointer */
    pointer_t * ptr = (pointer_t*)mxGetData(prhs[1]);
    ann_mex_t * annp = (ann_mex_t*)(*ptr);
    if ( ! annp->IsGood() )
        mexErrMsgIdAndTxt("annmex:pointer","internal data structure is faulty - possible wrong handle");

    if ( mode == CLOSE ) {
        delete annp;
        return;
    }

    /* for the search operations - extract the parameters */
    if ( nrhs < 3 )
        mexErrMsgIdAndTxt("annmex:inputs","must have at least 3 inputs");
    
    int k = 1; 
    if ( nrhs >= 4 )
        GetScalar(prhs[3], k);
    
    double eps = 0.0;
    if ( nrhs >= 5 )
        GetScalar(prhs[4], eps);

    if ( mode == FRSEARCH ) {
        if ( nrhs != 6 ) 
            mexErrMsgIdAndTxt("annmex:FRSEARCH_inputs","must have 6 inputs");
    }
    
    
    switch (mode) {
        case KSEARCH:
            if ( nlhs != 2 )
                mexErrMsgIdAndTxt("annmex:outputs","must have two output arguments");
            annp->annkSearch(prhs[2], k, &plhs[0], &plhs[1], eps);
            return;
        case PRISEARCH:
            if ( nlhs != 2 )
                mexErrMsgIdAndTxt("annmex:outputs","must have two output arguments");
            annp->annkPriSearch(prhs[2], k, &plhs[0], &plhs[1], eps);
            return;
        case FRSEARCH:            
            if ( nlhs != 3 )
                mexErrMsgIdAndTxt("annmex:outputs","must have three output arguments");
            annp->annkFRSearch(prhs[2], prhs[5], k, &plhs[0], &plhs[1], &plhs[2], eps);         
            return;
            
        default:
            mexErrMsgIdAndTxt("annmex:mode","unrecognized mode");
    }
                
    
}



/* ann_mex_t methods implementation */
ann_mex_t::ann_mex_t(const mxArray* mxPts)      // construct ann from a matrix
{
    index_t j(0);
    
    // we expect mxPts to be (d)x(N) matrix of type ANNcoord
    if ( mxGetNumberOfDimensions(mxPts) != 2 )
        mexErrMsgIdAndTxt("annmex:inputs","Expecting (d)x(N) input matrix");

    // dimension of points
    m_idim = mxGetM(mxPts);
    
    // number of points
    m_inpoints = mxGetN(mxPts);
    
    // check data type
    if ( mxCOORD_CLASS != mxGetClassID(mxPts) ) 
        mexErrMsgIdAndTxt("annmex:inputs","input points are of wrong type");
    
    // make a copy of the data - kd tree class does not hold a copy
    
    ANNpoint ptr = (ANNpoint)mxGetData(mxPts);
    pa = new ANNpoint[m_inpoints];
    pa[0] = new ANNcoord[m_inpoints*m_idim]; // allocate all the room for the points
    for ( j = 0 ; j < m_inpoints ; j++ ) {
        pa[j] = pa[0]+j*m_idim;
        memcpy(pa[j], ptr, m_idim * sizeof(ANNcoord));
        ptr += m_idim;        
    }
    m_pTree = new ANNkd_tree(pa, m_inpoints, m_idim, BUCKET_SIZE, KD_SPLIT_RULE);
    
    
    
    // final step - set the integrity flag 
    m_clintck = CLASS_INTEGRITY_CHECK;
}

ann_mex_t::~ann_mex_t()
{
    // free the tree
    if (IsGood() && m_pTree) {
        delete m_pTree;        
        delete [] pa[0];
        delete [] pa;
    }
    
    // cancel the integrity check
    m_clintck = 0;        
}

void 
ann_mex_t::annkSearch(					// approx k near neighbor search
            const mxArray*	mxQ,			// query point
            int				k,				// number of near neighbors to return
            mxArray**		mxIdx,			// nearest neighbor array (modified)
            mxArray**       mxDst,			// dist to near neighbors (modified)
            double			eps)		// error bound
{
    index_t j(0);
    int nqp(0); // number of query points
    
    if ( ! IsGood() )
        mexErrMsgIdAndTxt("annmex:annkSearch","Class integrity check failed");
    
    // check input point(s)
    // dimension of points
    if (m_idim != mxGetM(mxQ))
        mexErrMsgIdAndTxt("annmex:annkSearch","point dimension does not match");
    nqp = mxGetN(mxQ);
    if (nqp <= 0) 
        mexErrMsgIdAndTxt("annmex:annkSearch","need at least one query point");
    
    if ( k <= 0 )
        mexErrMsgIdAndTxt("annmex:annkSearch","k must be positive");
    
    if ( k > m_inpoints ) {
        // generate warning
        mexWarnMsgIdAndTxt("annmex:annkSearch","searching for more points than in tree - returning only %d",m_inpoints);
        k = m_inpoints;
    }
        
    // allocate space for outputs
    *mxIdx = mxCreateNumericMatrix(k, nqp, mxIDX_CLASS, mxREAL);
    *mxDst = mxCreateNumericMatrix(k, nqp, mxDIST_CLASS, mxREAL);
    if ( *mxIdx == NULL || *mxDst == NULL ) 
        mexErrMsgIdAndTxt("annmex:annkSearch","cannot allocate memory for outputs");
    
    ANNidx * pidx = (ANNidx*)mxGetData(*mxIdx);
    ANNdist* pdist= (ANNdist*)mxGetData(*mxDst);
    ANNpoint pp   = (ANNpoint)mxGetData(mxQ);
    
    for ( j = 0 ; j < nqp ; j++ ) {
        m_pTree->annkSearch(pp, k, pidx, pdist, eps);
        pp += m_idim;
        pidx += k;
        pdist += k;
    }
}
        
void 
ann_mex_t::annkPriSearch( 				// priority k near neighbor search
            const mxArray*	mxQ,			// query point
            int				k,				// number of near neighbors to return
            mxArray**		mxIdx,			// nearest neighbor array (modified)
            mxArray**       mxDst,			// dist to near neighbors (modified)
            double			eps)		// error bound
{
    index_t j(0);
    int nqp(0); // number of query points
    
    if ( ! IsGood() )
        mexErrMsgIdAndTxt("annmex:annkPriSearch","Class integrity check failed");
    
    // check input point(s)
    // dimension of points
    if (m_idim != mxGetM(mxQ))
        mexErrMsgIdAndTxt("annmex:annkPriSearch","point dimension does not match");

    nqp = mxGetN(mxQ);
    if (nqp <= 0) 
        mexErrMsgIdAndTxt("annmex:annkPriSearch","need at least one query point");

    if ( k <= 0 )
        mexErrMsgIdAndTxt("annmex:annkPriSearch","k must be positive");
    
    if ( k > m_inpoints ) {
        // generate warning
        mexWarnMsgIdAndTxt("annmex:annkPriSearch","searching for more points than in tree - returning only %d",m_inpoints);
        k = m_inpoints;
    }
        
    // allocate space for outputs
    *mxIdx = mxCreateNumericMatrix(k, nqp, mxIDX_CLASS, mxREAL);
    *mxDst = mxCreateNumericMatrix(k, nqp, mxDIST_CLASS, mxREAL);
    if ( *mxIdx == NULL || *mxDst == NULL ) 
        mexErrMsgIdAndTxt("annmex:annkPriSearch","cannot allocate memory for outputs");
    
    ANNidx * pidx = (ANNidx*)mxGetData(*mxIdx);
    ANNdist* pdist= (ANNdist*)mxGetData(*mxDst);
    ANNpoint pp   = (ANNpoint)mxGetData(mxQ);
    
    for ( j = 0 ; j < nqp ; j++ ) {
        m_pTree->annkPriSearch(pp, k, pidx, pdist, eps);
        pp += m_idim;
        pidx += k;
        pdist += k;
    }
   
}
       
void 
ann_mex_t::annkFRSearch(					// approx fixed-radius kNN search
            const mxArray*	mxQ,			// query points
            const mxArray*  mxRad,			// radius of query ball (a scalar or array of size N)
            int				k,				// number of near neighbors to return
            mxArray**		mxIdx,			// nearest neighbor array (modified)
            mxArray**       mxDst,			// dist to near neighbors (modified)
            mxArray**       mxInr,          // number of points within r of each point
            double			eps)		// error bound
{
    index_t j(0);
    
    if ( ! IsGood() )
        mexErrMsgIdAndTxt("annmex:annkFRSearch","Class integrity check failed");
    
    // check input point(s)
    // dimension of points
    if (m_idim != mxGetM(mxQ))
        mexErrMsgIdAndTxt("annmex:annkFRSearch","points dimension does not match");

    // number of query point(s)
    int nqp = mxGetN(mxQ);
   
    if ( k <= 0 )
        mexErrMsgIdAndTxt("annmex:annkFRSearch","k must be positive");
    
    if ( k > m_inpoints ) {
        // generate warning
        mexWarnMsgIdAndTxt("annmex:annkFRSearch","searching for more points than in tree - returning only %d",m_inpoints);
        k = m_inpoints;
    }
    
    int rad_array_inc = 1;
    if ( mxGetNumberOfElements(mxRad) == 1 )
        rad_array_inc = 0;
    else if ( mxGetNumberOfElements(mxRad) != nqp )
        mexErrMsgIdAndTxt("annmex:annkFRSearch","R must be either a scalar or array of size N");
    
    ANNdist* prad = new ANNdist[mxGetNumberOfElements(mxRad)];
    GetArrSq<ANNdist>(mxRad, prad);

   
    // allocate space for outputs
    *mxIdx = mxCreateNumericMatrix(k, nqp, mxIDX_CLASS, mxREAL);
    *mxDst = mxCreateNumericMatrix(k, nqp, mxDIST_CLASS, mxREAL);
    *mxInr = mxCreateNumericMatrix(1, nqp, mxINT32_CLASS, mxREAL);
    if ( *mxIdx == NULL || *mxDst == NULL || mxInr == NULL) 
        mexErrMsgIdAndTxt("annmex:annkPriSearch","cannot allocate memory for outputs");
    
    ANNidx * pidx = (ANNidx*)mxGetData(*mxIdx);
    ANNdist* pdist= (ANNdist*)mxGetData(*mxDst);
    int *    pinr = (int*)mxGetData(*mxInr);
    
    ANNpoint pp   = (ANNpoint)mxGetData(mxQ);
    
    for ( j = 0 ; j < nqp ; j++ ) {
        *pinr = m_pTree->annkFRSearch(pp, prad[rad_array_inc*j], k, pidx, pdist, eps);
        pp += m_idim;
        pidx += k;
        pdist += k;
        pinr ++;
    }
    delete [] prad; 
}

template<class T>
void GetArrSq(const mxArray* x, T* arr)
{
    int ii, n = mxGetNumberOfElements(x);
    void *p = mxGetData(x);
    char* cp;
    unsigned char* ucp;
    short* sp;
    unsigned short* usp;
    int* ip;
    unsigned int* uip;
    int64_T *i64p;
    uint64_T *ui64p;
    double* dp;
    float* fp;
    
    switch (mxGetClassID(x)) {
        case mxCHAR_CLASS:
        case mxINT8_CLASS:    
            cp = (char*)p;
            for ( ii = 0 ; ii < n ; ii++)
                arr[ii] = cp[ii]*cp[ii];
            return;
        case mxDOUBLE_CLASS:
            dp = (double*)p;
            for ( ii = 0 ; ii < n ; ii++)
                arr[ii] = dp[ii]*dp[ii];
            return;
        case mxSINGLE_CLASS:
            fp = (float*)p;
            for ( ii = 0 ; ii < n ; ii++)
                arr[ii] = fp[ii]*fp[ii];            
            return;
        case mxUINT8_CLASS:
            ucp = (unsigned char*)p;
            for ( ii = 0 ; ii < n ; ii++)
                arr[ii] = ucp[ii]*ucp[ii];
            return;
        case mxINT16_CLASS:
            sp = (short*)p;
            for ( ii = 0 ; ii < n ; ii++)
                arr[ii] = sp[ii]*sp[ii];
            return;
        case mxUINT16_CLASS:
            usp = (unsigned short*)p;
            for ( ii = 0 ; ii < n ; ii++)
                arr[ii] = usp[ii]*usp[ii];
            return;
        case mxINT32_CLASS:
            ip = (int*)p;
            for ( ii = 0 ; ii < n ; ii++)
                arr[ii] = ip[ii]*ip[ii];
            return;
        case mxUINT32_CLASS:
            uip = (unsigned int*)p;
            for ( ii = 0 ; ii < n ; ii++)
                arr[ii] = uip[ii]*uip[ii];
            return;
        case mxINT64_CLASS:
            i64p = (int64_T*)p;
            for ( ii = 0 ; ii < n ; ii++)
                arr[ii] = i64p[ii]*i64p[ii];
            return;
        case mxUINT64_CLASS:
            ui64p = (uint64_T*)p;
            for ( ii = 0 ; ii < n ; ii++)
                arr[ii] = ui64p[ii]*ui64p[ii];
            return;
        default:
            mexErrMsgIdAndTxt("annmex:GetArrSq","unsupported data type");
    }
}
        
