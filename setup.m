global base_dir
base_dir = cd;
path(path,[base_dir '/tools'])
path(path,[base_dir '/tools/models'])

% copy the cpp generation tool from BRITE directory. 
temp=dir('tools/models/cpp*');
if isempty(temp)
    !cp BRITE/C++/cppgen tools/models/cppgen
end
    
path(path,[base_dir '/graphviz']);      % graph viz interface files. 
path(path,[base_dir,'/matlab_bgl']);    % matlab bgl toolbox. 




