 fp = fopen(['glp_good_seed'], 'w+');
 R = floor(rand(6,3)*2^16);
 fprintf(fp,'PLACES %d %d %d\n',R(1,:));
 fprintf(fp,'CONNECT %d %d %d\n',R(2,:));
 fprintf(fp,'EDGE_CONN %d %d %d\n',R(3,:));
 fprintf(fp,'GROUPING %d %d %d\n',R(4,:));
 fprintf(fp,'ASSIGNMENT %d %d %d\n',R(5,:));
 fprintf(fp,'BANDWIDTH %d %d %d\n',R(6,:));
 fclose(fp);

