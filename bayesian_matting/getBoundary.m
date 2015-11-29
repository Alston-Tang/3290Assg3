function [boundary] = getBoundary(img, trimap, target, inQ)
    import java.util.LinkedList;
    boundary = LinkedList();
    for i = 1 : size(img, 1)
        for j = 1 : size(img, 2)
            if trimap(i,j) == target
               for ox = -1:2:1
                    for oy = -1:2:1
                        if (i+oy < 1 || i+oy > size(img, 1) || j+ox < 1 || j+ox > size(img,2))
                            break;
                        end
                        if trimap(i+oy, j+ox) ~= target
                            inQ(i, j) = 1;
                            boundary.add([i,j]);
                        end
                    end
                end 
            end
        end
    end
end

