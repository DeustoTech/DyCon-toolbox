function GeneratePrintAMPL(file)
%GENERATEPRINTAMPL Summary of this function goes here
%   Detailed explanation goes here



f =fopen(file);
AMPLContent = fscanf(f,'%c');
AMPLContent = replace(AMPLContent,'=',' ');
AMPLContent = replace(AMPLContent,':',' ');

cellAMPL = splitlines(AMPLContent);

boolean_index = arrayfun(@(i) contains(cellAMPL{i},'param')||contains(cellAMPL{i},'var'),1:length(cellAMPL));

CellParams = cellAMPL(boolean_index);
for i = 1:length(CellParams)
    line = strsplit(CellParams{i},' ');
    linepre = strsplit(CellParams{i},{'{', '}'});
    CellParams{i} = line{2};

    if length(linepre)>2
        pre = ['{',linepre{2},'}'];
        iter = 0;
        for idim = strsplit(linepre{2},',') 
            idim = strsplit(idim{:},'in');
            iter = iter + 1;
            indexname{iter} = idim{1};
            idim = strsplit(idim{2},'..');
        end
        CellDimension{i} = [' # Variable - ',CellParams{i},';'];
        indexname = join(indexname,',');
        post = ['[',indexname{:},']'];
    else
        pre = '';
        CellDimension{i} = [' # Variable - ',CellParams{i},';'];
        post = '';
    end
    CellParams{i} = ['printf ',pre,' : ','" %24.16e\n",',CellParams{i},post,';' ];
end

for i = 1:length(CellParams)
   display( CellDimension{i}) 
  
  display( CellParams{i}) 
    display(' ')
end
end

