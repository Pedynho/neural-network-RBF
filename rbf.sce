clear;
clc;
warning('off');

function r = funcTest(amostra,M,X,N,q)
    xtest = X(:,amostra);
    for i=1:N
        for j=1:q
            Z_test(j,i) = exp(-norm(xtest-T(:,j))^2);
        end
    end
    Z_test = [(-1)*ones(1,N);Z_test];
    y_test = M * Z_test;
    [val i] = max(abs(y_test));
    r = i;
endfunction

base = fscanfMat("two_classes.dat");

X = base(:,1:2)';
Y = base(:,3)';

//normalizando os dados
for i=1:2
    X(i,:) = (X(i,:)-mean(X(i,:))/stdev(X(i,:)));
end

a = X(1,:);
b = X(2,:);

//numero de amostras e quantidade de caracteristicas
N = 1000;
P = 2;

Q = 10; //quantidade de neurônios ocultos

Z = zeros(Q,N);
T = rand(P,Q,'normal'); //centroides aleatorios

for i=1:N
    for j=1:Q
        Z(j,i) = exp(-norm(X(:,i)-T(:,j))^2);
    end
end

//gerando a saida
Z = [(-1)*ones(1,N);Z];
M = Y * Z' * (Z*Z')^(-1);
yc = M*Z;

//plotando pontos
scatter(a(1:500),b(1:500), "scilabred2", ".");
scatter(a(501:1000),b(501:1000), "scilabblue2", "." );

//tentando plotar a curva

x1 = linspace(min(a),max(a), 100);
x2 = linspace(min(b),max(b), 100);
pd = zeros(2,100*100);
cont = 1;
for k = 1:100
    for i = 1:100
        Zt = zeros(Q,1);
        for j=1:Q
            Zt(j,1) = exp(-norm([x1(k);x2(i)]-T(:,j))^2);
        end
        Zt = [(-1);Zt];
        st = M*Zt;
        if abs(st) < 0.05 then  
            pd(1,cont) = x1(k)
            pd(2,cont) = x2(i)
            cont = cont + 1
        end  
    end
end
plot(pd(1,:),pd(2,:), "k.");



//teste
amostraId = 458;
iYc = funcTest(amostraId,M,X,N,Q);
disp(yc(iYc),Y(amostraId));
