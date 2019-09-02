/* My variables */
/* loc locbal inv invbal ils ilsbal mm mmbal mmcred mtg */

/* Set up Macro */
%let var = loc;

/* Set up Libname */
libname log "C:/Users/shawn/OneDrive/Desktop/LogisticRegression_Files/HMWK/HMWK_1";

/* Check for missing values & 0's */
/* INV missing 1075 */
/* INVBAL missing 1075 */
/* All BAL variables have 0's in them */

proc freq data=log.insurance_t;
	tables &var;
run;

/* Check association on categorical variables and the target variable */
/* Independence is assumed from data */
proc freq data=log.insurance_t;
	tables mtg*ins / chisq measures cl;
run;

/* Checking assumptions */
/* Can't use Box-Tidwell since all have 0's as values and INVBAL is missing 1075 observations */
/* Use General Additive Model (GAM) */
/* Of my continuous variables, only LOCBAL had an insignificant P-value for GAM */
/* Therefore, only LOCBAL meets the assumption of linearity of the logit */

proc gam data=log.insurance_t plots = components (clm commonaxes);
	model ins(event='1') = spline(&var, df=4) / dist=binomial link=logit;
run;

/* Logistic Regression to obtain Odd Ratios */
proc logistic data=log.insurance_t plots(only) = (oddsratio);
	model ins(event='1') = mtg / clodds=pl clparm=pl;
run;
quit;

/* Variable investigation for unusual or interesting behavior */
/* Descriptive Statistics */
ods graphics on;
proc univariate data = log.insurance_t plots;
	var loc locbal inv invbal ils ilsbal mm mmbal mmcred mtg;
	histogram;
run;


	