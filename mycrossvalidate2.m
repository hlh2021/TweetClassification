function [ output ] = mycrossvalidate2( input, label, nfold )


clabel = unique(label);
nclass = length(clabel);

input = (1:length(input))';

permn=cell(1,nclass);
sc_fea=cell(1,nclass);
sc_label=cell(1,nclass);
output=cell(nfold,4);
for jj=1:nclass
    
    permn{1,jj} = crossvalind('Kfold', sum(label==clabel(jj)), nfold);

    sc_fea{1,jj}=input(label==clabel(jj),:);
    sc_label{1,jj}=label(label==clabel(jj));

end

for ii=1:nfold
    tr_fea=[];
    ts_fea=[];
    tr_label=[];
    ts_label=[];
    for jj=1:nclass

    tr_fea=[tr_fea;sc_fea{1,jj}(permn{1,jj}~=ii,:)];
    ts_fea=[ts_fea;sc_fea{1,jj}(permn{1,jj}==ii,:)];
    
    tr_label=[tr_label; sc_label{1,jj}(permn{1,jj}~=ii,:)];
    ts_label=[ts_label; sc_label{1,jj}(permn{1,jj}==ii,:)];
    end
    
    output{ii,1} = tr_fea;
    output{ii,2} = tr_label;
    output{ii,3} = ts_fea;
    output{ii,4} = ts_label;
end

end

