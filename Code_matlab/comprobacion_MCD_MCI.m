%% Comprobación de que el MCI y el MCD funcionan
% Jorge F. García-Samartín
% www.gsamartin.es
% 2023-05-16

L = 10*rand(15,3);
Lp = zeros(size(L));
a = 1 + 10*rand(1);

for i = 1:size(L,1)
    T = MCD(L(i,:),a);
    x = T(1:3,4);
    Lp(i,:) = MCI(x,a);
end

disp(norm(L-Lp));