PRO myexample

FOR i=1,9 DO BEGIN

    simage=mrdfits('/Users/Elizabeth/Desktop/M51/'+StrTrim(i,2)+'/sibsab'+StrTrim(i,2)+'_0p03.fits',1,hdrs)
    nimage=mrdfits('/Users/Elizabeth/Desktop/M51/'+StrTrim(i,2)+'/nibsa'+StrTrim(i,2)+'010_drz.fits',1,hdr)


    ; Get a file for analysis.
    filename='sibsab'+STRTRIM(i,2)+'.jpeg'
    file = FILEPATH(filename,ROOT_DIR='/Users',SUBDIRECTORY='/Elizabeth/Desktop/M51/jpegs/')
    READ_JPEG, file, image, /GRAYSCALE
    
    ; Define a structuring kernal for an opening operation on the image.
    radius = 4
    kernel = SHIFT(DIST(2*radius+1), radius, radius) LE radius
    
    ; Apply the opening operator to the image.
    openImage = MORPH_OPEN(image, kernel, /GRAY)
    
    ; Threshold the image to prepare to remove background noise.
    ; Notice that changing this value can produce more or less
    ; artifacts. You will have to decide what you can live with
    ; in your analysis. It requires some judgement on your part.
    mask = openImage GE 130 

    ; Do the analysis.
    blobs = Obj_New('blob_analyzer', openImage, MASK=mask)
    
    ; Display the original image
    s = Size(image, /DIMENSIONS)
    cgDisplay, 800, 800, Aspect=image, Title='H II regions'
    cgLoadCT, 0
    cgImage, image, Position=[0.0, 0.5, 0.5, 1.0]
    
    ; Display the opened image beside it.
    cgImage, openImage, Position=[0.5, 0.5, 1.0, 1.0], /NoErase
    
    ; Display the blobs we located with LABEL_REGION.
    countblobs = blobs -> NumberOfBlobs()
    blank = BytArr(s[0], s[1])
    FOR j=0,countblobs-1 DO BEGIN
        blobIndices = blobs -> GetIndices(j)
        blank[blobIndices] = image[blobIndices]
    ENDFOR
    cgImage, blank, Position=[0.0, 0.0, 0.5, 0.5], /NoErase
    
    ; Display the original image, with blob outlined and labelled.
    cgImage, image, Position=[0.5, 0.0, 1.0, 0.5], /NoErase, $
        /Save, XRange=[0,1], YRange=[0,1]

    FOR j=0,countblobs-1 DO BEGIN
    
        ; Convert the perimeter points into normalized data coordinates.
        stats = blobs -> GetStats(j, /NoScale)
        xpts = Reform(stats.perimeter_pts[0,*]) / Float(s[0])
        ypts = Reform(stats.perimeter_pts[1,*]) / Float(s[1])
        xcenter = stats.center[0] / Float(s[0])
        ycenter = stats.center[1] / Float(s[1])
        cgPlots, xpts, ypts, COLOR='dodger blue', /DATA
        cgText, xcenter, ycenter, StrTrim(j,2), $
            COLOR='red', ALIGNMENT=0.5, CHARSIZE=2, FONT=0, /DATA
    ENDFOR
    
    ; Add labels for captions.
    cgText, 0.05, 0.95, 'A', FONT=0, ALIGNMENT=0.5, COLOR='Yellow', /NORMAL
    cgText, 0.55, 0.95, 'B', FONT=0, ALIGNMENT=0.5, COLOR='Yellow', /NORMAL
    cgText, 0.05, 0.45, 'C', FONT=0, ALIGNMENT=0.5, COLOR='Yellow', /NORMAL
    cgText, 0.55, 0.45, 'D', FONT=0, ALIGNMENT=0.5, COLOR='Yellow', /NORMAL
    
    ; Report stats.
    blobs -> ReportStats

    ;Print newIndices
    FOR j=0L, countblobs-1L DO BEGIN
    newIndices=blobs -> GetIndices(j)
    IF j eq 0 THEN BEGIN
    blobIndices=newIndices
    ENDIF ELSE BEGIN
    blobIndices=[blobIndices,0,newIndices]
    ENDELSE
    ENDFOR

;Get the number of pixels in a blob
numpix=make_array(countblobs)
FOR j=0L,countblobs-1L DO BEGIN     
areastats = blobs -> GetStats(j, /NoScale)
numpix(j) = areastats.count
ENDFOR
    
    ; Destroy the object.
    Obj_Destroy, blobs

;GETAD.PRO 

;get the value of "count", which is the number of H II regions in the ith image
length=size(blobIndices, /N_ELEMENTS)
count=1
for j=0, length-1 do begin
if (blobIndices(j) eq 0) then begin
count=count+1
endif 
endfor

;make empty "avg" and "ad" arrays
avg=make_array(count,1)
ad=make_array(count,2)

;fill in "ad" array (and "avg" array along the way)
index=0
for j=0, length-2 do begin
if (blobIndices(j) ne 0) then begin
avg(index)=mean(blobIndices(j))
x=avg(index) mod 1089
y=avg(index)/1089
xyad,hdr,x,y,a,d
ad(index,0)=a
ad(index,1)=d
endif else begin
index=index+1
endelse
endfor

;GETSUM.PRO

;making sum, the array of size "count"
sum=make_array(count)
length=size(blobIndices, /N_ELEMENTS)
indexer=0
for k=0, length-2 do begin
if (blobIndices(k) ne 0) then begin
sum(indexer) = sum(indexer) + simage(blobIndices(k))
endif else begin
indexer=indexer+1
endelse
endfor

;LR.PRO

;defining the array "lum"... 
lum=sum*4.91853

;getting lumr
count=size(sum,/N_ELEMENTS)
lumr=make_array(2,count)
for j=0, count-1 do begin
lumr(0,j)=lum(j) ;luminosity of the region in 10^-35 erg/s
lumr(1,j)=(7.845E+06)*(1/(2.063E+05))*(sqrt(((3600.)*(abs(ad(j,0)-202.4696292))*Cos((3.14159/180)*47.1951772))^2+((3600.)*(abs(ad(j,1)-47.1951772)))^2)) ;galactocentric distance in pc
endfor

;getting luma
count=size(sum,/N_ELEMENTS)
luma=make_array(3,count)
for n=0,count-1 do begin
luma(0,n)=lum(n) ;luminosity of the region in 10^-35 erg/s
luma(1,n)=lumr(1,n) ;galactocentric distance in pc
;luma(2,n)=((7.845*10^6)*(1/(2.063*10^5)))^2*(((3600.)*(ad(0,0)-ad(1,0))*Cos((180/3.14159)*47.1951772))^2+((3600.)*(ad(0,1)-ad(1,1)))^2)*numpix(n) ;area in pc^2
luma(2,n)=(0.13)^2*(7.845E+06)^2*(1/(2.063E+05))^2*numpix(n) ;area in pc^2
endfor

;getting lumad
count=size(sum,/N_ELEMENTS)
lumad=make_array(3,count)
for m=0, count-1 do begin
lumad(0,m)=lum(m) ;luminosity of the region in 10^-35 erg/s
lumad(1,m)=ad(m,0) ;RA of region in degrees
lumad(2,m)=ad(m,1) ;Dec of region in degrees
endfor

;writing them to .csv files
write_csv,'/Users/Elizabeth/Desktop/M51/'+STRTRIM(i,2)+'/lumr'+STRTRIM(i,2)+'.csv',lumr
write_csv,'/Users/Elizabeth/Desktop/M51/'+STRTRIM(i,2)+'/lumd'+STRTRIM(i,2)+'.csv',lumad
write_csv,'/Users/Elizabeth/Desktop/M51/'+STRTRIM(i,2)+'/luma'+STRTRIM(i,2)+'.csv',luma

ENDFOR

END 
