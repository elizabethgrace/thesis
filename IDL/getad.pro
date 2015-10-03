pro getad,hdr,ad ;gets RA and Dec coordinates of H II regions

;To create an empty array that has dimension equal to the number of blobs in the image as specified by blobIndices. I also make an empty array that has two spots for every blob, which will be filled with the blob's RA and Dec.
length=size(blobIndices, /N_ELEMENTS)
count=1
for i=0, length-1 do begin
if (blobIndices(i) eq 0) then begin
count=count+1
endif 
endfor
avg=make_array(count,1)
ad=make_array(count,2)

;Creating an index that indexes the blobs
index=0

;For the indexth blob, find its average blobIndex, convert that blobIndex to x and y, and then find the RA and Dec for that blobIndex. Then for the indexth blob, get its RA and Dec. 
for i=0, length-2 do begin
if (blobIndices(i) ne 0) then begin

avg(index)=mean(blobIndices(i))

x=avg(index) mod 1089
y=avg(index)/1089

xyad,hdr,x,y,a,d
ad(index,0)=a
ad(index,1)=d

endif else begin
index=index+1
endelse
endfor
end


