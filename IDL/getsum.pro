pro getsum,blobIndices,image,sum

length=size(blobIndices, /N_ELEMENTS)
count=1

for i=0, length-1 do begin
if (blobIndices(i) eq 0) then begin
count=count+1
endif 
endfor

sum=make_array(count)

index=0

for i=0, length-2 do begin
if (blobIndices(i) ne 0) then begin
sum(index) = sum(index) + image(blobIndices(i))
endif else begin
index=index+1
endelse
endfor
end

