function [boundaryList] = getBoundary(trimap, target, crit)
import java.util.LinkedList

boundaryList = LinkedList();
h = size(trimap, 1);
w = size(trimap, 2);


for i = 2:h-1
    for j = 2:w-1
        if trimap(i,j) == target
            t1 = trimap(i, j-1);
            t2 = trimap(i, j+1);
            t3 = trimap(i-1, j);
            t4 = trimap(i+1, j);
            if t1 == crit || t2 == crit || t3 == crit || t4 == crit
                boundaryList.add([i,j]);
            end
        end
    end
end


end

