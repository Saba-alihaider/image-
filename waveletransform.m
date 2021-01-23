clear all;
close all;
clc;
img=imread('0002-0.jpg');
hsvimg=rgb2hsv(img);
figure;
subplot(211), imshow(img); title('original image'); 
subplot(212), imshow(hsvimg(:,:,3)); title('intensity of image');

[xav,xhv,xvv,xdv] = dwt2(hsvimg(:,:,3),'db2');

%figure,
%subplot(221),imshow(xav);
%subplot(222),imshow(xhv);
%subplot(223),imshow(xvv);
%subplot(224),imshow(xdv);

x1=[xav , xhv ; xvv , xdv];
figure,imshow(x1); title('1 level decomposition');

[xxav,xxhv,xxvv,xxdv] = dwt2(xav,'db2');

%figure,
%ubplot(221),imshow(xxav);
%subplot(222),imshow(xxhv);
%subplot(223),imshow(xxvv);
%subplot(224),imshow(xxdv);

x2=[xxav , xxhv ; xxvv , xxdv];
%figure,imshow(x11);

[r,c,s]=size(xvv);
x3=[x2(1:r,1:c,:) ,xhv ; xvv , xdv];
figure, imshow(x3); title('2 level decomposition');

%===============================================================%


% Gathering the data to train on from an image

bb=8;
K=121;
IMin0=x3;
IMin0=im2double(IMin0);
%figure(1); imshow('cameraman.tif');
blkMatrix=im2col(IMin0,[bb,bb],'sliding');
TrainData=blkMatrix(:,1:10:end);

% Initial dictionary

DCT=zeros(bb,sqrt(K));
for k=0:1:sqrt(K)-1,
    V=cos([0:1:bb-1]'*k*pi/sqrt(K));
    if k>0, V=V-mean(V); 
    end;
    DCT(:,k+1)=V/norm(V);
end
DCT=kron(DCT,DCT);
I1=DispDict(DCT, sqrt(K),sqrt(K),bb,bb,0);
figure(2); imshow(I1); 
 
