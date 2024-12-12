function main
    tic;
    clc; clear all; close all;

    % Parameters
    % Change db_folder to the folder name of the database you want to use
    % For example:
    % db_folder = 'Kimia99_DB';
    db_folder = 'TARI_DB';
    
    img_size = [64 64]; % Adjust as needed
    num_classes = 9;    % Adjust according to your dataset
    num_samples = 11;   % Adjust according to your dataset
    
    listing = dir(db_folder);
    % Note: Check if the listing indexing +2 offset is suitable for TARI_DB. 
    % If the dataset structure differs (for example, no need for +2 indexing), adjust the indexing in the code accordingly.
    
    % Training phase
    [bw_train, vr_train] = trainPhase(listing, db_folder, num_classes, num_samples, img_size);

    % Testing phase
    [num_rec, assignment_matrix] = testPhase(listing, db_folder, bw_train, vr_train, num_classes, num_samples, img_size);

    elapsed_time = toc;
    disp('Completed.');
    disp(['Elapsed time: ', num2str(elapsed_time)]);
end

function [bw_train, vr_train] = trainPhase(listing, db_folder, num_classes, num_samples, img_size)
    % This function processes the training images from the specified database folder.
    % It extracts the largest ellipse for each image and computes the vertices.
    
    bw_train = cell(num_classes,1);
    vr_train = cell(num_classes,1);
    
    for train_no = 1:num_samples
        for class_indx = 1:num_classes
            
            tmp_indx = (class_indx-1)*num_samples + train_no;
            % Adjust indexing if necessary depending on the dataset structure.
            tmp_indx = tmp_indx + 2; 
            filename = listing(tmp_indx).name;
            
            bw = im2bw(imread(fullfile(db_folder, filename)),0);
            bw_resized = imresize(bw, img_size);
            bw_train{class_indx} = bw_resized;
            
            s = regionprops(bw_resized, {...
                'Centroid','MajorAxisLength','MinorAxisLength','Orientation','PixelList','Area'});
            
            % Select the ellipse with the largest area
            [max_indx] = selectMaxAreaEllipse(s);
            
            vr_train{class_indx} = computeVertices(s(max_indx));
        end
    end
end

function [num_rec, assignment_matrix] = testPhase(listing, db_folder, bw_train, vr_train, num_classes, num_samples, img_size)
    % This function tests the images from the specified database folder.
    % It compares each test image with the training set and computes an overlap ratio to determine recognition.
    
    num_rec = zeros(num_classes,num_samples);
    assignment_matrix = cell(num_samples,1);

    for train_no = 1:num_samples
        rec_indx = zeros(num_classes, num_samples);
        for class_indx = 1:num_classes
            for tst_indx = 1:num_samples
                if tst_indx == train_no
                    continue
                end
                
                % Load the test image from the specified database folder
                tmp_indx = (class_indx-1)*num_samples + tst_indx;
                tmp_indx = tmp_indx + 2;
                filename = listing(tmp_indx).name;
                bw = im2bw(imread(fullfile(db_folder, filename)),0);
                bw_resized = imresize(bw, img_size);
                
                s = regionprops(bw_resized, {...
                    'Centroid','MajorAxisLength','MinorAxisLength','Orientation','PixelList','Area'});
                
                [max_indx] = selectMaxAreaEllipse(s);
                orgvr = computeVertices(s(max_indx)); % Vertices of the test image
                
                [best_class] = findBestMatch(bw_train, vr_train, orgvr, s(max_indx));
                
                rec_indx(class_indx, tst_indx) = best_class;
                if best_class == class_indx
                    num_rec(class_indx, train_no) = num_rec(class_indx, train_no) + 1;
                end
            end
        end
        assignment_matrix{train_no} = rec_indx;
    end
end

function [max_indx] = selectMaxAreaEllipse(s)
    % Selects the ellipse with the largest area from the regionprops result
    if isempty(s)
        max_indx = [];
        return;
    end
    size_ellipse = [s.Area];
    [~, max_indx] = max(size_ellipse);
end

function vr = computeVertices(s_ellipse)
    % Computes the four vertices representing the endpoints of the major and minor axes of the ellipse.
    
    cx = s_ellipse.Centroid(1);
    cy = s_ellipse.Centroid(2);
    theta = s_ellipse.Orientation;
    a = s_ellipse.MajorAxisLength/2;
    b = s_ellipse.MinorAxisLength/2;

    % Minor axis vertices
    x1 = cx - b*sind(theta);
    y1 = cy - b*cosd(theta);
    x2 = cx + b*sind(theta);
    y2 = cy + b*cosd(theta);

    % Major axis vertices
    x3 = cx + a*cosd(theta);
    y3 = cy - a*sind(theta);
    x4 = cx - a*cosd(theta);
    y4 = cy + a*sind(theta);

    vr = [x1 y1; x3 y3; x2 y2; x4 y4];
end

function [best_class] = findBestMatch(bw_train, vr_train, orgvr, s_test)
    % Finds the class with the best overlap match for the test image compared to the training set.
    
    num_classes = length(bw_train);
    cntr_indx = zeros(num_classes,4);
    
    PL2 = s_test.PixelList; % Pixel list of the test image
    ln2 = length(PL2);
    
    for org_class_indx = 1:num_classes
        cs_orgvr = circularShifts(orgvr);
        cs_vr = circularShifts(vr_train{org_class_indx});
        
        tmp_k = 0;
        s_train = regionprops(bw_train{org_class_indx},{...
            'Centroid','MajorAxisLength','MinorAxisLength','Orientation','PixelList','Area'});

        [org_max_indx] = selectMaxAreaEllipse(s_train);
        if isempty(org_max_indx)
            continue;
        end
        PL = s_train(org_max_indx).PixelList;
        ln1 = length(PL);

        % In the original code, this loop was executed once, but you can modify if needed.
        for i = 1:1
            coor_1 = cs_orgvr{i};
            coor_im1 = [coor_1(1:3,:)'; ones(1,3)];
            
            % Try four different vertex orderings
            for j = 1:4
                tmp_k = tmp_k + 1;
                coor_2 = cs_vr{j};
                coor_im2 = [coor_2(1:3,:)'; ones(1,3)];
                
                % Compute transformation matrix M
                M = coor_im1(1:3,:) * pinv(coor_im2(1:3,:));

                cntr_ratio = computeOverlapRatio(M, PL, PL2, ln1, ln2);
                cntr_indx(org_class_indx, tmp_k) = cntr_ratio;
            end
        end
    end
    [~, best_class] = max(max(cntr_indx, [], 2));
end

function shifts = circularShifts(vr)
    % Creates four circular shifts of the given vertex set.
    
    shifts = cell(1,4);
    shifts{1} = vr;
    for i = 2:4
        shifts{i} = circshift(shifts{i-1},1);
    end
end

function cntr_ratio = computeOverlapRatio(M, PL, PL2, ln1, ln2)
    % Computes the overlap ratio between transformed training image pixels and
    % test image pixels. M is the transformation matrix.
    
    PL_hom = [PL ones(ln1,1)];
    PL_hom_pro = round(M * PL_hom')';
    PL_pro = PL_hom_pro(:,1:2);
    PL_pro = unique(PL_pro,'rows');

    cntr = 0;
    for i=1:size(PL_pro,1)
        cntr = cntr + sum(PL2(:,1) == PL_pro(i,1) & PL2(:,2) == PL_pro(i,2));
    end

    cntr_ratio = cntr/ln1;
end
