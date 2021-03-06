#' Conditional Maximization Routine for the Indirect Estimation of Origin-Destination Migration Flow Table with Known Margins.
#'
#' The \code{cm2} function finds the maximum likelihood estimates for parameters in the log-linear model:
#' \deqn{ \log y_{ij} = \log \alpha_i + \log \beta_j + \log m_{ij} }
#' as introduced by Willekens (1999). The \eqn{\alpha_i} and  \eqn{\beta_j} represent background information related to  the characteristics of the origin and destinations respectively. The \eqn{m_{ij}} factor represents auxiliary information on migration flows, which imposes its interaction structure onto the estimated flow matrix.
#' @param rtot Vector of origin totals to constrain the sum of the imputed cell rows.
#' @param ctot Vector of destination totals to constrain the sum of the imputed cell columns.
#' @param m Matrix of auxiliary data. By default set to 1 for all origin-destination combinations. 
#' @param tol Numeric value for the tolerance level used in the parameter estimation.
#' @param maxit Numeric value for the maximum number of iterations used in the parameter estimation.
#' @param verbose Logical value to indicate the print the parameter estimates at each iteration. By default \code{FALSE}.
#'
#' @return
#' Parameter estimates are obtained using the EM algorithm outlined in Willekens (1999). This is equivalent to a conditional maximization of the likelihood, as discussed by Raymer et. al. (2007). It also provides identical indirect estimates to those obtained from the \code{\link{ipf2}} routine. 
#' 
#' The user must ensure that the row and column totals are equal in sum. Care must also be taken to allow the dimension of the auxiliary matrix (\code{m}) to equal those provided in the row (\code{rtot}) and column (\code{ctot}) arguments.
#' 
#' Returns a \code{list} object with
#' \item{N }{Origin-Destination matrix of indirect estimates}
#' \item{theta }{Collection of parameter estimates}
#' @references 
#' Raymer, J., G. J. Abel, and P. W. F. Smith (2007). Combining census and registration data to estimate detailed elderly migration flows in England and Wales. \emph{Journal of the Royal Statistical Society: Series A (Statistics in Society)} 170 (4), 891--908.
#' 
#' Willekens, F. (1999). Modelling Approaches to the Indirect Estimation of Migration Flows: From Entropy to EM. \emph{Mathematical Population Studies} 7 (3), 239--78.
#' @author Guy J. Abel
#' @seealso \code{\link{ipf2}}
#' @export
#'
#' @examples
#' ## with Willekens (1999) data
#' dn <- LETTERS[1:2]
#' y <- cm2(rtot = c(18, 20), ctot = c(16, 22), 
#'          m = matrix(c(5, 1, 2, 7), ncol = 2, dimnames = list(orig = dn, dest = dn)))
#' y
#' 
#' ## with all elements of offset equal (independence fit)
#' y <- cm2(rtot = c(18, 20), ctot = c(16, 22))
#' y
#' 
#' ## with bigger matrix
#' dn <- LETTERS[1:3]
#' y <- cm2(rtot = c(170, 120, 410), ctot = c(500, 140, 60), 
#'          m = matrix(c(50, 10, 220, 120, 120, 30, 545, 0, 10), 
#'                     ncol = 3, 
#'                     dimnames = list(orig = dn, dest = dn)))
#'                     
#' # display with row and col totals
#' round(addmargins(y$N)) 
cm2 <- function(rtot = NULL, ctot = NULL, m = matrix(1,length(rtot),length(ctot)),
                tol = 1e-05, maxit = 500, verbose = TRUE)
{
  if(round(sum(rtot))!=round(sum(ctot))) 
    stop("row and column totals are not equal, ensure sum(rtot)==sum(ctot)")
  i<-dim(m)[1];  j<-dim(m)[2]
  alpha <- rep(1,i)
  beta <- rep(1,j)
  if(verbose==TRUE){
    rd<-paste("%.",nchar(format(tol,scientific=FALSE))-2,"f",sep="")
    cat(sprintf(rd,c(alpha,beta)), fill = TRUE)
  }
  alpha.old <- alpha+1; beta.old <- beta+1
  it<-1;  max.diff<-tol*2
  while(max.diff>tol & it<maxit ){
    beta.old <- beta
    for(j in 1:j) {
      beta[j] <- ctot[j]/sum(alpha * m[, j])
    }
    alpha.old <- alpha
    for(i in 1:i) {
      alpha[i] <- rtot[i]/sum(beta * m[i,  ])
    }
    it<-it+1
    max.diff<-max(abs(alpha-alpha.old), abs(beta-beta.old))
    if(verbose==TRUE)
      cat(sprintf(rd,c(alpha,beta)), fill = TRUE)
  }
  return(list(N = alpha %*% t(beta)*m,
              theta=c(mu=1,alpha=alpha,beta=beta)))
}
