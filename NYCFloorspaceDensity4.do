drop _all 
graph drop _all
program drop _all 

/* Import data from CartoDB */
import delimited ///
	"https://dl.dropboxusercontent.com/s/o3b92oc1cvd1rud/Final_Dataset.csv"

/* graph settings */
global gsize small
global gsym o /// d is diamond, t is triangle
	
/* Convert to log scale */
gen log_s = log10(s)
gen log_dist = log10(dist_from_esb)

/* Regression of log scale data */
regress log_s log_dist
predict log_p

/* basic scatter plot of floorspace density (s) by census tract vs distance from ESB */
twoway  (scatter s dist_from_esb if boroname == "Bronx", msize($gsize) msymbol($gsym)) ///
		(scatter s dist_from_esb if boroname == "Brooklyn", msize($gsize) msymbol($gsym)) ///
		(scatter s dist_from_esb if boroname == "Manhattan", msize($gsize) msymbol($gsym)) ///
		(scatter s dist_from_esb if boroname == "Queens", msize($gsize) msymbol($gsym)) ///
		(scatter s dist_from_esb if boroname == "Staten Island", msize($gsize) msymbol($gsym)) ///
		,legend(label(1 "Bronx") label(2 "Brooklyn") label(3 "Manhattan") label(4 "Queens") label(5 "Staten Island") col(5))  ///
		name(s_density, replace) ///
		title("Floorspace Density (s) by Census Tract") ///
		title("vs Distance from NYC City Center", suffix) ///
		xtitle(Distance from Empire State Building) ytitle(Floorspace Density)
	
/* scatter plot (log scale) of floorspace density (s) by census tract vs distance from ESB with regression line */
twoway  (scatter log_s log_dist if boroname == "Bronx" & log_s >= -2 , msize($gsize) msymbol($gsym)) ///
		(scatter log_s log_dist if boroname == "Brooklyn" & log_s >= -2 , msize($gsize) msymbol($gsym)) ///
		(scatter log_s log_dist if boroname == "Manhattan" & log_s >= -2 , msize($gsize) msymbol($gsym)) ///
		(scatter log_s log_dist if boroname == "Queens" & log_s >= -2 , msize($gsize) msymbol($gsym)) ///
		(scatter log_s log_dist if boroname == "Staten Island" & log_s >= -2 , msize($gsize) msymbol($gsym)) ///
		(line log_p log_dist) ///
		,legend(label(1 "Bronx") label(2 "Brooklyn") label(3 "Manhattan") label(4 "Queens") label(5 "Staten Island") col(5)) ///
		name(log_s_density, replace) ///
		title("Floorspace Density (s) by Census Tract (Log)") ///
		title("vs Distance from NYC City Center (Log)", suffix) ///
		xtitle(Log Distance from Empire State Building) ytitle(Log Floorspace Density)
	
nl (s = {b0}*exp(-1*{b1}*dist_from_esb)) 
/*nl (ct_density = {b0}*dist_from_esb^({b1})) */
predict nlp

/* scatter plot (linear scale) of floorspace density (s) by census tract vs distance from ESB with nonlinear regression line */
twoway  (scatter s dist_from_esb if boroname == "Bronx", msize($gsize) msymbol($gsym)) ///
		(scatter s dist_from_esb if boroname == "Brooklyn", msize($gsize) msymbol($gsym)) ///
		(scatter s dist_from_esb if boroname == "Manhattan", msize($gsize) msymbol($gsym)) ///
		(scatter s dist_from_esb if boroname == "Queens", msize($gsize) msymbol($gsym)) ///
		(scatter s dist_from_esb if boroname == "Staten Island", msize($gsize) msymbol($gsym)) ///
		(line nlp dist_from_esb, sort) ///
		,legend(label(1 "Bronx") label(2 "Brooklyn") label(3 "Manhattan") label(4 "Queens") label(5 "Staten Island") col(5)) ///
		name(density_pred, replace) ///
		title("Floorspace Density (s) by Census Tract") ///
		title("vs Distance from NYC City Center", suffix) ///
		xtitle(Distance from Empire State Building) ytitle(Floorspace Density)
	
/* scatter plot (semilog scale) of floorspace density (s) by census tract vs distance from ESB with nonlinear regression line */
twoway  (scatter s dist_from_esb if boroname == "Bronx", msize($gsize) msymbol($gsym)) ///
		(scatter s dist_from_esb if boroname == "Brooklyn", msize($gsize) msymbol($gsym)) ///
		(scatter s dist_from_esb if boroname == "Manhattan" & dist_from_esb != 0, msize($gsize) msymbol($gsym)) ///drop the one tract that IS the Empire State Building!
		(scatter s dist_from_esb if boroname == "Queens", msize($gsize) msymbol($gsym)) ///
		(scatter s dist_from_esb if boroname == "Staten Island", msize($gsize) msymbol($gsym)) ///
		(line nlp dist_from_esb if dist_from_esb != 0, sort) ///
		,xscale(log) ///
		legend(label(1 "Bronx") label(2 "Brooklyn") label(3 "Manhattan") label(4 "Queens") label(5 "Staten Island") col(5)) ///
		name(density_pred2, replace) ///
		title("Floorspace Density (s) by Census Tract") ///
		title("vs Distance from NYC City Center (Log)", suffix) ///
		xtitle(Log Distance from Empire State Building) ytitle(Floorspace Density)

/* scatter plot (linear scale) of lot density (l) by census tract vs distance from ESB */
twoway  (scatter l dist_from_esb if boroname == "Bronx", msize($gsize) msymbol($gsym)) ///
		(scatter l dist_from_esb if boroname == "Brooklyn", msize($gsize) msymbol($gsym)) ///
		(scatter l dist_from_esb if boroname == "Manhattan", msize($gsize) msymbol($gsym)) ///
		(scatter l dist_from_esb if boroname == "Queens", msize($gsize) msymbol($gsym)) ///
		(scatter l dist_from_esb if boroname == "Staten Island", msize($gsize) msymbol($gsym)) ///
		,yscale(range(0 1)) ///
		legend(label(1 "Bronx") label(2 "Brooklyn") label(3 "Manhattan") label(4 "Queens") label(5 "Staten Island") col(5)) ///
		name(l_density, replace) ///
		title("Lot Density (ℓ) by Census Tract") ///
		title("vs Distance from NYC City Center", suffix) ///
		xtitle(Distance from Empire State Building) ytitle("Lot Density(ℓ)")

/* scatter plot (linear scale) of FAR density (f) by census tract vs distance from ESB */
twoway  (scatter f dist_from_esb if boroname == "Bronx", msize($gsize) msymbol($gsym)) ///
		(scatter f dist_from_esb if boroname == "Brooklyn", msize($gsize) msymbol($gsym)) ///
		(scatter f dist_from_esb if boroname == "Manhattan", msize($gsize) msymbol($gsym)) ///
		(scatter f dist_from_esb if boroname == "Queens", msize($gsize) msymbol($gsym)) ///
		(scatter f dist_from_esb if boroname == "Staten Island", msize($gsize) msymbol($gsym)) ///
		,legend(label(1 "Bronx") label(2 "Brooklyn") label(3 "Manhattan") label(4 "Queens") label(5 "Staten Island") col(5)) ///
		name(f_density, replace) ///
		title("Floor Area Ratio (f) by Census Tract") ///
		title("vs Distance from NYC City Center", suffix) ///
		xtitle(Distance from Empire State Building) ytitle("Floor Area Ratio (f)")

/* scatter plot (linear scale) of footprint density (p) by census tract vs distance from ESB */
twoway  (scatter p dist_from_esb if boroname == "Bronx", msize($gsize) msymbol($gsym)) ///
		(scatter p dist_from_esb if boroname == "Brooklyn", msize($gsize) msymbol($gsym)) ///
		(scatter p dist_from_esb if boroname == "Manhattan", msize($gsize) msymbol($gsym)) ///
		(scatter p dist_from_esb if boroname == "Queens", msize($gsize) msymbol($gsym)) ///
		(scatter p dist_from_esb if boroname == "Staten Island", msize($gsize) msymbol($gsym)) ///
		,yscale(range(0 1) extend) ylabel(0(.2)1) ///
		legend(label(1 "Bronx") label(2 "Brooklyn") label(3 "Manhattan") label(4 "Queens") label(5 "Staten Island") col(5)) ///
		name(p_density, replace) ///
		title("Footprint Density (p) by Census Tract") ///
		title("vs Distance from NYC City Center", suffix) ///
		xtitle(Distance from Empire State Building) ytitle("Footprint Density (p)")

/* scatter plot (linear scale) of footprint to lot area ratio (r) by census tract vs distance from ESB */
twoway  (scatter r dist_from_esb if boroname == "Bronx", msize($gsize) msymbol($gsym)) ///
		(scatter r dist_from_esb if boroname == "Brooklyn", msize($gsize) msymbol($gsym)) ///
		(scatter r dist_from_esb if boroname == "Manhattan", msize($gsize) msymbol($gsym)) ///
		(scatter r dist_from_esb if boroname == "Queens", msize($gsize) msymbol($gsym)) ///
		(scatter r dist_from_esb if boroname == "Staten Island", msize($gsize) msymbol($gsym)) ///
		,yscale(range(0 1)) ///
		legend(label(1 "Bronx") label(2 "Brooklyn") label(3 "Manhattan") label(4 "Queens") label(5 "Staten Island") col(5)) ///
		name(r_density, replace) ///
		title("Footprint to Lot Area Ratio (r) by Census Tract") ///
		title("vs Distance from NYC City Center", suffix) ///
		xtitle(Distance from Empire State Building) ytitle("Footprint to Lot Area Ratio (r)")
		
/* scatter plot (linear scale) of FAR density (f) by census tract vs lot density (l) by census tract */
twoway  (scatter f l if boroname == "Bronx", msize($gsize) msymbol($gsym)) ///
		(scatter f l if boroname == "Brooklyn", msize($gsize) msymbol($gsym)) ///
		(scatter f l if boroname == "Manhattan", msize($gsize) msymbol($gsym)) ///
		(scatter f l if boroname == "Queens", msize($gsize) msymbol($gsym)) ///
		(scatter f l if boroname == "Staten Island", msize($gsize) msymbol($gsym)) ///
		, ///yscale(range(0 1)) ///
		legend(label(1 "Bronx") label(2 "Brooklyn") label(3 "Manhattan") label(4 "Queens") label(5 "Staten Island") col(5)) ///
		name(f_vs_l_density, replace) ///
		title("Floor Area Ratio (f) by Census Tract") ///
		title("vs Lot Density (ℓ) by Census Tract", suffix) ///
		xtitle("Lot Density (ℓ) by Census Tract") ytitle("Floor Area Ratio (f) by Census Tract")

/* scatter plot (linear scale) of floorspace density (s) by census tract vs lot density (l) by census tract */
twoway  (scatter s l if boroname == "Bronx", msize($gsize) msymbol($gsym)) ///
		(scatter s l if boroname == "Brooklyn", msize($gsize) msymbol($gsym)) ///
		(scatter s l if boroname == "Manhattan", msize($gsize) msymbol($gsym)) ///
		(scatter s l if boroname == "Queens", msize($gsize) msymbol($gsym)) ///
		(scatter s l if boroname == "Staten Island", msize($gsize) msymbol($gsym)) ///
		, ///yscale(range(0 1)) ///
		legend(label(1 "Bronx") label(2 "Brooklyn") label(3 "Manhattan") label(4 "Queens") label(5 "Staten Island") col(5)) ///
		name(s_vs_l_density, replace) ///
		title("Floorspace Density (s) by Census Tract") ///
		title("vs Lot Density (ℓ) by Census Tract", suffix) ///
		xtitle("Lot Density (ℓ) by Census Tract") ytitle("Floorspace Density (s) by Census Tract")
