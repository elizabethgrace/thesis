PRO myexample2

    ; Get a file for analysis.
   FOR i=1,9 DO BEGIN
   filename='sibsab'+STRTRIM(i,2)+'.jpeg'
   file = FILEPATH(filename,ROOT_DIR='/Users',SUBDIRECTORY='/Elizabeth/Desktop/M51/jpegs/')
    READ_JPEG, file, image, /GRAYSCALE
    ;image=simage
    
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
numpix[j] = areastats.count
ENDFOR
    
    ; Destroy the object.
    Obj_Destroy, blobs

lr,i,lumr,lumad,luma
write_csv,lumr,'/Users/Elizabeth/Desktop/M51/'+STRTRIM(i)+'/lroutput'+STRTRIM(i,2)+'.csv'
write_csv,lumad,'/Users/Elizabeth/Desktop/M51/'+STRTRIM(i)+'/ladoutput'+STRTRIM(i,2)+'.csv'
write_csv,luma,'/Users/Elizabeth/Desktop/M51/'+STRTRIM(i)+'/area'+STRTRIM(i,2)+'.csv'
ENDFOR

END ;
