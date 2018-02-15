close all; clear all;clc;
%% Superpixel Segmentation
A = im2double(imread('test3.jpg'));imshow(A);
[L,NumLabels] = superpixels(A,100);
figure;
BW = boundarymask(L);
imshow(imoverlay(A,BW,'cyan'))
cd = zeros(size(A),'like',A);
idx = label2idx(L);
numRows = size(A,1);
numCols = size(A,2);
%% Optimization
% initialization
for labelVal = 1:NumLabels
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    cd(redIdx) = mean(A(redIdx));
    cd(greenIdx) = mean(A(greenIdx));
    cd(blueIdx) = mean(A(blueIdx));
    
end    

cs= im2double(200*ones(size(A),'uint8'));
md= 0.5*ones(size(A,1),size(A,2));ms= 0.5*ones(size(A,1),size(A,2));
% 
numiter=1000;alpha= 0.3;
cd_k = zeros(size(A),'like',A);
md_k= zeros(size(md),'like',md);
ms_k= zeros(size(ms),'like',ms);
cs_k= zeros(size(A),'like',A);
% Iteration
for k=1:numiter
 % c_d   
    for labelVal = 1:NumLabels
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal}+numRows*numCols;
        blueIdx = idx{labelVal}+2*numRows*numCols;
        cd_k(redIdx) = (cd(redIdx)- alpha*2*(md(redIdx).*(md(redIdx).*cd(redIdx)+ms(redIdx).*cs(redIdx)-A(redIdx))));
        cd_k(greenIdx) = (cd(greenIdx)- alpha*2*(md(redIdx).*(md(redIdx).*cd(greenIdx)+ms(redIdx).*cs(greenIdx)-A(greenIdx))));
        cd_k(blueIdx) = (cd(blueIdx)- alpha*2*(md(redIdx).*(md(redIdx).*cd(blueIdx)+ms(redIdx).*cs(blueIdx)-A(blueIdx))));
    end
    
    for i=1:numRows*numCols
 % m_d       
        md_k(i)=md(i)-alpha*2*(([cd(i),cd(i+numRows*numCols),cd(i+2*numRows*numCols)])*...
            (md(i)*([cd(i);cd(i+numRows*numCols);cd(i+2*numRows*numCols)])...
            +ms(i)*([cs(i);cs(i+numRows*numCols);cs(i+2*numRows*numCols)])...
            -[A(i);A(i+numRows*numCols);A(i+2*numRows*numCols)]));
            
 % m_s       
        ms_k(i)=ms(i)-alpha*2*(([cs(i),cs(i+numRows*numCols),cs(i+2*numRows*numCols)])*...
            (md(i)*([cd(i);cd(i+numRows*numCols);cd(i+2*numRows*numCols)])...
            +ms(i)*([cs(i);cs(i+numRows*numCols);cs(i+2*numRows*numCols)])...
            -[A(i);A(i+numRows*numCols);A(i+2*numRows*numCols)]));
 % c_s       
        
        cs_k(i)= cs(i)-alpha*2*ms(i)*(md(i)*cd(i)...
            +ms(i)*cs(i)-A(i));
        cs_k(i+numRows*numCols)= cs(i+numRows*numCols)-alpha*2*ms(i)*...
            (md(i)*cd(i+numRows*numCols)+ms(i)*...
            cs(i+numRows*numCols)-A(i+numRows*numCols));
        cs_k(i+2*numRows*numCols)= cs(i+2*numRows*numCols)-alpha*2*ms(i)*...
            (md(i)*cd(i+2*numRows*numCols)+ms(i)*...
            cs(i+2*numRows*numCols)-A(i+2*numRows*numCols));
    end
    
 % norm criterion   
    R1 = cd(:,:,1); R2 = cd_k(:,:,1);
    G1 = cd(:,:,2); G2 = cd_k(:,:,2);
    B1 = cd(:,:,3); B2 = cd_k(:,:,3);
    s = (R1-R2).^2+(G1-G2).^2+(B1-B2).^2;
    s = s(:);
    d= sqrt(sum(s)); 
    
    if abs(d)<1e-3
        break
    end
 % updating cs,ms,cd,md   
    
    cs(:,:,1)= mean(mean(cs_k(:,:,1)))*ones(size(cs,1),size(cs,2));
    cs(:,:,2)= mean(mean(cs_k(:,:,2)))*ones(size(cs,1),size(cs,2));
    cs(:,:,3)= mean(mean(cs_k(:,:,3)))*ones(size(cs,1),size(cs,2));
    %alpha_md= md_k-md
    md= md_k;ms= ms_k;cd= cd_k;
end

figure;
imshow(md);title('md');figure;
imshow(cd);title('cd');figure;
imshow(ms);title('ms');figure;
imshow(cs);title('cs');figure;
imshow(md.*cd);title('md*cd');figure;
imshow(ms.*cs);title('ms*cs');figure;
imshow(md.*cd+ms.*cs);title('md*cd+ms*cs')

