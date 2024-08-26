function f = preprocessVideo(path, saveas)
    pls = [1 1];
    omegagauss = 0;
    write = true; 

    vidObj = VideoReader(path);
    framesOG = read(vidObj);

    f.T = vidObj.NumFrames;
    H = vidObj.Height;
    W = vidObj.Width;
    f.fps = vidObj.FrameRate;

    for t = 1:f.T
        if pls(1) == 1 && pls(2) == 1
            f.frames1(:,:,t) = (framesOG(:,:,2,t) + framesOG(:,:,3,t))/2;
        else
            f.frames1(:,:,t) = (strided_avging(pls(1), pls(2), framesOG(:,:,2,t), H, W) ...
                + strided_avging(pls(1), pls(2), framesOG(:,:,3,t), H, W))/2;
        end

        if omegagauss ~= 0
            f.frames(:,:,t) = imgaussfilt(f.frames1(:,:,t),omegagauss);
        end
    end

    if omegagauss == 0
        f.frames = f.frames1;
    end

    clear f.frames1

    [f.H, f.W, f.T] = size(f.frames);

    if write == true
        v = VideoWriter(saveas);
        v.FrameRate = f.fps;
        open(v)
        for i = 1:f.T
            writeVideo(v,(f.frames(:,:,i)-min(f.frames(:,:,i),[],'all'))/max(f.frames(:,:,i)-min(f.frames(:,:,i),[],'all'),[],'all'));
        end
        close(v)
    end

    save(saveas, 'f')
end
