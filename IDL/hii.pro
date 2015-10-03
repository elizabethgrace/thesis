pro hii,simage,minval,simagehii

simagehii = simage
hii = where(simagehii GT minval, complement=nothii)
simagehii(hii) = 1
simagehii(nothii) = 0

for i=0,1087 do begin
for j=0,961 do begin
if (simagehii[i,j] eq 1) then begin
if (simagehii[i+1,j] eq 1) or (simagehii[i+1,j+1] eq 1) or (simagehii[i+1,j-1] eq 1) or (simagehii[i-1,j] eq 1) or (simagehii[i-1,j-1] eq 1) or (simagehii[i-1,j+1] eq 1) or (simagehii[i,j+1] eq 1) or (simagehii[i,j-1] eq 1) then begin
simagehii[i,j]=1
endif else begin
simagehii[i,j]=0
endelse
endif else begin
simagehii[i,j]=0
endelse
endfor
endfor

for i=0,1086 do begin
for j=0,960 do begin
if (simagehii[i,j] eq 1) then begin
if (simagehii[i+2,j] eq 1) or (simagehii[i+2,j+1] eq 1) or (simagehii[i+2,j-1] eq 1) or (simagehii[i+2,j+2] eq 1) or (simagehii[i+2,j-2] eq 1) or (simagehii[i-2,j] eq 1) or (simagehii[i-2,j+1] eq 1) or (simagehii[i-2,j-1] eq 1) or (simagehii[i-2,j+2] eq 1) or (simagehii[i-2,j-2] eq 1) or (simagehii[i,j+2] eq 1) or (simagehii[i-1,j+2] eq 1) or (simagehii[i+1,j+2] eq 1) or (simagehii[i,j-2] eq 1) or (simagehii[i-1,j-2] eq 1) or (simagehii[i+1,j-2] eq 1) then begin
simagehii[i,j]=1
endif else begin
simagehii[i,j]=0
endelse
endif else begin
simagehii[i,j]=0
endelse
endfor
endfor

for i=0,1087 do begin
for j=0,961 do begin
if (simagehii[i,j] eq 1) then begin
if (simagehii[i+1,j] eq 1) or (simagehii[i+1,j+1] eq 1) or (simagehii[i+1,j-1] eq 1) or (simagehii[i-1,j] eq 1) or (simagehii[i-1,j-1] eq 1) or (simagehii[i-1,j+1] eq 1) or (simagehii[i,j+1] eq 1) or (simagehii[i,j-1] eq 1) then begin
simagehii[i,j]=1
endif else begin
simagehii[i,j]=0
endelse
endif else begin
simagehii[i,j]=0
endelse
endfor
endfor


for i=0,1086 do begin
for j=0,960 do begin
if (simagehii[i,j] eq 1) then begin
if (simagehii[i+2,j] eq 1) or (simagehii[i+2,j+1] eq 1) or (simagehii[i+2,j-1] eq 1) or (simagehii[i+2,j+2] eq 1) or (simagehii[i+2,j-2] eq 1) or (simagehii[i-2,j] eq 1) or (simagehii[i-2,j+1] eq 1) or (simagehii[i-2,j-1] eq 1) or (simagehii[i-2,j+2] eq 1) or (simagehii[i-2,j-2] eq 1) or (simagehii[i,j+2] eq 1) or (simagehii[i-1,j+2] eq 1) or (simagehii[i+1,j+2] eq 1) or (simagehii[i,j-2] eq 1) or (simagehii[i-1,j-2] eq 1) or (simagehii[i+1,j-2] eq 1) then begin
simagehii[i,j]=1
endif else begin
simagehii[i,j]=0
endelse
endif else begin
simagehii[i,j]=0
endelse
endfor
endfor


end
