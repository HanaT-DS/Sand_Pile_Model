proc iml;
    
    n = 201; /* Grid size */
    sand = j(1, n*n, 0); /* Create an empty grid */
    center = (n*n + 1) / 2;
    sand[center] = 2**16; /* Add sand at the center */
    med = sand[center];

    /* Main loop: continues as long as there are elements >= 4 */
    do while (ncol(loc(sand >= 4)) > 0);
        
        ind = loc(sand >= 4); /* Find indices of cells with more than 4 grains */
        sand[ind] = sand[ind] - 4; /* The cell loses 4 grains */

        /* Redistribution to neighbors */
        
        /* Transfer to the left */
        if mod(ind, n) ^= 0 then 
            sand[ind - 1] = sand[ind - 1] + 1; /* First column: mod(ind, n) = 0 */

        /* Transfer to the right */
        if mod(ind, n) ^= n - 1 then 
            sand[ind + 1] = sand[ind + 1] + 1; /* Last column: mod(ind, n) = n - 1 */

        /* Transfer upwards */
        if ind - n >= 0 then 
            sand[ind - n] = sand[ind - n] + 1;

        /* Transfer downwards */
        if ind + n < n*n then 
            sand[ind + n] = sand[ind + n] + 1;

    end;

    sand_finale = shape(sand, n, n);

    /* Prepare data for visualization */
    x = j(1, n, 1); 
    do i = 2 to n; 
        x = x || j(1, n, i); 
    end; /* X-coordinates */

    y = shape(1:n, n*n, 1); /* Y-coordinates */
    z = sand[loc(sand >= 0)]; /* Values used to define the color */

    /* Create dataset for visualization */
    create sand_data var {x y z};
    append;
    close sand_data;

quit;

/* Display the sandpile */
title 'Sand Pile Model';
proc sgplot data = sand_data;
    heatmapparm x = x y = y colorresponse = z / colormodel = (CXc0c0c0 CX9ee149 CX6e44b4 CXf3d10e);
run;
