

% for j = 1:1027
%     while 1
% 
%         prueba(j,:) = -50 + 50*randi(fix(((900)/50 + 1)), [1 3]);
%     
%         indice = find(prueba(j,:) == min(prueba(j,:)));
%     
%         if (prueba(j,indice(1)) ~= 0) && (isempty(find(prueba(j,:) == 0, 1)))
%             prueba(j,indice(1)) = 0;
%         end
% 
%         if isempty(find(ismember(prueba(j,:),prueba(1:j-1,:),'rows') == 1,1))
%             break;
%         end
%     end
% end


