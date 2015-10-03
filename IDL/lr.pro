pro lr,k,lumr,lumad,luma

image=mrdfits('nibsa'+STRTRIM(k,2)+'010_drz.fits',1,hdr)

;get sum
getsum,blobIndices,image,sum

;get ad where ad(i,0) is the RA and ad(i,1) is the Dec of the ith blob
getad,hdr,ad

;The conversion factor from sum to luminosity is approximately 4.9E35, but it doesn't like that so I'm using just 4.9. So lum is in erg/s times 10^35. 
lum=sum*4.91853

count=size(sum,/N_ELEMENTS)
lumr=make_array(2,count)
for j=0, count-1 do begin
lumr(0,j)=lum(j) ;luminosity of the region
lumr(1,j)=7.845*sqrt((abs(ad(j,0)-202.4696292)*Cos(47.1951772))^2 + (abs(ad(j,1)-47.1951772))^2) ;galactocentric distance
endfor

count=size(sum,/N_ELEMENTS)
lumad=make_array(3,count)
for j=0, count-1 do begin
lumad(0,j)=lum(j) ;luminosity of the region
lumad(1,j)=ad(j,0) ;RA of region in degrees
lumad(2,j)=ad(j,1) ;Dec of region in degrees
endfor


count=size(sum,/N_ELEMENTS)
luma=make_array(5,count)
for j=0,count-1 do begin
luma(0,j)=lum(j) ;luminosity of the region
luma(1,j)=7.845*sqrt(((ad(j,0)-202.4696292)*Cos((3.14159/180)*47.1951772))^2 +(ad(j,1)-47.1951772)^2) ;galactocentric distance in Mpc
luma(2,j)= ((0.13 * 7.845)^2)*numpix(j) ;Area in 10^-6 kpc^2
endfor
end

