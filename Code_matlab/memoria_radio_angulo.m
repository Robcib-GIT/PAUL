for i = 1:360 
    a(i,1) = gamma_(i);  
    a(i,2) = gamma_(i + 120); 
    a(i,3) = gamma_(i + 240); 
end

t = (1: 1 : 481);

figure;
hold on
title("Función gamma_")
xlabel("Ángulo")
plot(t(1:360),a(1:360,1));
xlim([1,360])
xline(120)
xline(240)
xline(360)

figure;
subplot(3,1,1);
hold on
title("Curvatura = 1000")
xlabel("Ángulo")
ylabel("F * curvatura")
plot(t,1000*a);
legend("SX3", "SX2", "SX1")

subplot(3,1,2);
hold on
title("Curvatura = 500")
xlabel("Ángulo")
ylabel("F * curvatura")
plot(t,500*a);
legend("SX3", "SX2", "SX1")

subplot(3,1,3);
hold on
title("Curvatura = 100")
xlabel("Ángulo")
ylabel("F * curvatura")
plot(t,100*a);
legend("SX3", "SX2", "SX1")