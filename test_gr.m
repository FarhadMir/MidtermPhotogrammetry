close all; clear all;clc;
%% Superpixel Segmentation
A = im2double(imread('test.jpg'));imshow(A);
[L,NumLabels] = superpixels(A,100);
figure;
BW = boundarymask(L);
imshow(imoverlay(A,BW,'cyan'))
outputImage = zeros(size(A),'like',A);
idx = label2idx(L);
numRows = size(A,1);
numCols = size(A,2);

for labelVal = 1:NumLabels
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    outputImage(redIdx) = mean(A(redIdx));
    outputImage(greenIdx) = mean(A(greenIdx));
    outputImage(blueIdx) = mean(A(blueIdx));
    
end    
figure
imshow(outputImage);
%% Optimization
% initialization
cd= im2double(200*ones(size(A),'uint8'));cs= im2double(200*ones(size(A),'uint8'));
md= 0.5*ones(size(A,1),size(A,2));ms= 0.5*ones(size(A,1),size(A,2));
numiter=1000;alpha= 0.4;
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
        cd_k(redIdx) = mean(cd(redIdx)- alpha*(2*md(redIdx).*(md(redIdx).*cd(redIdx)+ms(redIdx).*cs(redIdx)-A(redIdx))));
        cd_k(greenIdx) = mean(cd(greenIdx)- alpha*(2*md(redIdx).*(md(redIdx).*cd(greenIdx)+ms(redIdx).*cs(greenIdx)-A(greenIdx))));
        cd_k(blueIdx) = mean(cd(blueIdx)- alpha*(2*md(redIdx).*(md(redIdx).*cd(blueIdx)+ms(redIdx).*cs(blueIdx)-A(blueIdx))));
    end
    
    a=0;b=0;
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
    
    if abs(d)<1e-6
        break
    end
 % updating cs,ms,cd,md   
    
    cs(:,:,1)= mean(mean(cs_k(:,:,1)))*ones(size(cs,1),size(cs,2));
    cs(:,:,2)= mean(mean(cs_k(:,:,2)))*ones(size(cs,1),size(cs,2));
    cs(:,:,3)= mean(mean(cs_k(:,:,3)))*ones(size(cs,1),size(cs,2));
    md= md_k;ms= ms_k;cd= cd_k;
end

figure;
imshow(md);figure;
imshow(cd);figure;
imshow(ms);figure;
imshow(cs);

