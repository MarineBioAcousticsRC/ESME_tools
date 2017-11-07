function batch_tl(indir, freq,varargin)

% BATCH_TL  Batch modification of ESME output files text files into
% transmission loss matrices, and saves the information to a .mat file.
%
% Required inputs:
%   indir = The directory in which your ESME-derived output files are
%           located.
%           **FIRST MOVE THEM OUT OF THE ESME OUTPUT DIRECTORY**
%           ESME output files are generally found in:
%   C:\Users\YourName\AppData\Roaming\ESME Workbench\Database\scenarios\
%
%   freq =  The frequency, or vector of frequencies for which you'd like to
%           compute propagation models. Frequencies are in Hz.
%
% Optional inputs
%   plotFlag : {1 (on), 0 (off, default)}
%   maxTL: Maximum allowed transmission loss in dB peak to peak at frequency
%   of interest, for plotting purposes only.
%
% Example usage:
%   batch_tl('E:\ESME_output\SOCAL_Jan\kjxmmm23\',[2000:1000:10000],1,210)
%
%   This will take all the radial files in the input directory, and create
%   directories in "E:\ESME_output\SOCAL_Jan\kjxmmm23\" for each frequency
%   requested (2,4,6,8,and 10 kHz)
%
%
% Note: I also have code to make changes to sediment composition
% assumptions. That isn't implemented here yet, but can be added if needed.
plotFlag = 0 ;
maxTL = [];

if nargin <2
    disp('ERROR: Too few input arguments')
elseif nargin == 3
    newSedStr = varargin{1};
else
    newSedStr = [];
end
for itr = 1:length(freq)
    % Choose frequency to run:
    thisFreqHz =  freq(itr);
    
    % Re-write files with new frequency and useful filenames.
    outdir = edit_bellhop_inputs(indir,thisFreqHz,newSedStr);
    
    % run bellhop
    run_bellhop(fullfile(indir,outdir))
    
    % Extract transmission loss from bellhop outputs
    matOut = ESME_TL_3D(fullfile(indir,outdir));
    savePath = [indir, '\', 'freq_TL.mat'];
    save(savePath,'-mat')
    
%     if plotFlag == 1
%         % Plot mean attenuation as a function of distance and frequency for this site.
%         figure(101);
%         clf
%         [cmap, ~, ~, ~, ~] = cptcmap('GMT_wysiwygcont.cpt',...
%             gca, 'mapping', 'scaled', 'ncol', 256);
%         colormap(flipud(cmap));
%         
%         TLmean_thresh = TLmean;
%         if ~isempty(maxTL)
%             [mthresh, nthresh] = find(TLmean >= maxTL);
%             
%             for mitr = 1: length(mthresh)
%                 m = mthresh(mitr);
%                 n = nthresh(mitr);
%                 TLmean_thresh(m, n) = maxTL;
%             end
%             
%         end
%         
%         im_h = imagesc(.005:.005:20, (freq/1000),(real(TLmean_thresh(:,1:4000))));
%         set(im_h,'FontSize', 14);
%         ylabel('Frequency (kHz)', 'FontSize', 14)
%         xlabel('Distance (km)', 'FontSize', 14)
%         cb_h = colorbar;
%         set(cb_h, 'FontSize', 14)
%         ylabel(cb_h, 'Transmission Loss(dB)')
%     end
end