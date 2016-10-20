function [behavior,subjects,properties]=loadbehavior(filename,subjects,properties)
% Extracts columns labeled with the list of properties with rows matching
% list of subjects. Filename needs to point to an xls file. Returns NaN
% when an entry was missing. IMPORTANT: Code assumes that there are no
% row and column labels beyond where the data matrix is, and that there are
% no numbers in the column/row labels

[data,text] = xlsread(filename);
data(find(data==9999))=NaN;
offset = size(text)-size(data); % IMPORTANT: see note above

labelR = {text{offset(1)+1:end,1}};
labelC = {text{1,offset(2)+1:end}};

columns = findmatch(labelC,properties); c=~isnan(columns);
rows    = findmatch(labelR,subjects);   r=~isnan(rows);
behavior = nan(length(rows),length(columns));
behavior(r,c) = data(rows(r),columns(c));
subjects = {labelR{rows}};
properties = {labelC{columns}};

function [indx,list2]=findmatch(list1,list2)
% find index in list1 that match each string in list2. If list 2 is emty,
% return all.
if ~iscell(list2), list2={list2}; end;
if  length(list2)==0,
    indx=1:length(list1);
else
    indx = nan(1,length(list2));
    for i=1:length(list2)
        for j=1:length(list1)
            if strcmpi(list2{i},list1{j}) % found it!
                indx(i) = j;
            end
        end
        if isnan(indx(i))
            warning(['Missing entry: ' list2{i}]);
        end
    end
end
