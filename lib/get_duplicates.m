function duplicates = get_duplicates(list)
    [D, ~, X] = unique(list);
    Y = hist(X, unique(X));
    Z = struct('name', D, 'frequency', num2cell(Y(:)));
    duplicates = [];
    for i=1:size(Z, 1)
        if Z(i).frequency > 1
            duplicates = [duplicates; Z(i).name];
        end
    end
end
