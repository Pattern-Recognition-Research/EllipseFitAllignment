
# EllipseFitAllignment: Object Detection and Alignment using Elliptical Fitting

## Overview
The `EllipseFitAllignment` MATLAB script is a modular solution for object detection using elliptical fitting on binary images. It trains a model on a dataset, tests unseen images, and evaluates recognition accuracy by analyzing geometric alignment and pixel overlap.

This document serves as a detailed manual explaining each function, its purpose, and how to use it.

---

## Key Functions and Their Descriptions

### 1. `main`
**Purpose**: The main entry point for the script. It orchestrates the entire training and testing process.

**Inputs**: None (uses hardcoded parameters in the script).

**Outputs**:
- Recognition accuracy and elapsed execution time displayed in the MATLAB console.

**Usage**:
Run the `main` function in MATLAB:
```matlab
main
```

### 2. `initializeDataset`
**Purpose**: Prepares the dataset by scanning the directory and initializing storage for recognition results.

**Inputs**:
- `datasetPath` (string): Path to the dataset folder.
- `numClasses` (int): Number of object classes in the dataset.
- `numImagesPerClass` (int): Number of images per class.

**Outputs**:
- `listing`: Directory listing of the dataset folder.
- `num_rec`: Pre-initialized array for storing recognition counts.

**Usage**:
```matlab
[listing, num_rec] = initializeDataset('Kimia99_DB', 9, 11);
```

### 3. `trainPhase`
**Purpose**: Processes the training images, extracts the largest ellipse for each image, and computes its vertices.

**Inputs**:
- `listing`: Directory listing of the dataset.
- `db_folder` (string): Path to the dataset folder.
- `num_classes` (int): Number of classes in the dataset.
- `num_samples` (int): Number of samples per class.
- `img_size` (array): Dimensions for resizing images (e.g., `[64, 64]`).

**Outputs**:
- `bw_train`: Cell array storing binary training images.
- `vr_train`: Cell array storing vertices of the largest ellipse for each training image.

**Usage**:
```matlab
[bw_train, vr_train] = trainPhase(listing, 'Kimia99_DB', 9, 11, [64, 64]);
```

### 4. `testPhase`
**Purpose**: Tests unseen images against the trained model by computing overlap ratios and determining recognition accuracy.

**Inputs**:
- `listing`: Directory listing of the dataset.
- `db_folder` (string): Path to the dataset folder.
- `bw_train`: Binary images from the training phase.
- `vr_train`: Vertices of the largest ellipses for training images.
- `num_classes` (int): Number of classes.
- `num_samples` (int): Number of samples per class.
- `img_size` (array): Image dimensions for resizing.

**Outputs**:
- `num_rec`: Recognition counts for each class.
- `assignment_matrix`: Classification results for each test image.

**Usage**:
```matlab
[num_rec, assignment_matrix] = testPhase(listing, 'Kimia99_DB', bw_train, vr_train, 9, 11, [64, 64]);
```

### 5. `computeVertices`
**Purpose**: Computes the four vertices of an ellipse’s major and minor axes.

**Inputs**:
- `s_ellipse`: A structure containing the properties of the ellipse (from `regionprops`).

**Outputs**:
- `vr` (array): Coordinates of the ellipse's vertices.

**Usage**:
```matlab
vr = computeVertices(s_ellipse);
```

### 6. `findBestMatch`
**Purpose**: Identifies the class that best matches the test image by comparing its ellipse vertices to those of the training images.

**Inputs**:
- `bw_train`: Binary training images.
- `vr_train`: Vertices of training images’ ellipses.
- `orgvr`: Vertices of the test image’s ellipse.
- `s_test`: Region properties of the test image.

**Outputs**:
- `best_class` (int): The class index of the best match.

**Usage**:
```matlab
best_class = findBestMatch(bw_train, vr_train, orgvr, s_test);
```

### 7. `computeOverlapRatio`
**Purpose**: Calculates the overlap ratio between the transformed training image and the test image.

**Inputs**:
- `M` (matrix): Transformation matrix for aligning training and test image vertices.
- `PL` (array): Pixel coordinates of the training image.
- `PL2` (array): Pixel coordinates of the test image.
- `ln1` (int): Number of white pixels in the training image.
- `ln2` (int): Number of white pixels in the test image.

**Outputs**:
- `cntr_ratio` (float): Overlap ratio.

**Usage**:
```matlab
cntr_ratio = computeOverlapRatio(M, PL, PL2, ln1, ln2);
```

### 8. `circularShifts`
**Purpose**: Creates four circular shifts of the given vertex set to account for different vertex orders during alignment.

**Inputs**:
- `vr` (array): Original vertex set.

**Outputs**:
- `shifts`: A cell array containing all circular shifts of the vertex set.

**Usage**:
```matlab
shifts = circularShifts(vr);
```

### 9. `selectMaxAreaEllipse`
**Purpose**: Identifies the ellipse with the largest area from the `regionprops` results.

**Inputs**:
- `s`: Array of structures from `regionprops`.

**Outputs**:
- `max_indx` (int): Index of the largest ellipse.

**Usage**:
```matlab
max_indx = selectMaxAreaEllipse(s);
```

---

## Example Workflow
```matlab
% Step 1: Initialize the dataset
[listing, num_rec] = initializeDataset('Kimia99_DB', 9, 11);

% Step 2: Train the model
[bw_train, vr_train] = trainPhase(listing, 'Kimia99_DB', 9, 11, [64, 64]);

% Step 3: Test the model
[num_rec, assignment_matrix] = testPhase(listing, 'Kimia99_DB', bw_train, vr_train, 9, 11, [64, 64]);

% Step 4: Display results
disp('Recognition results:');
disp(num_rec);
disp('Assignment matrix:');
disp(assignment_matrix);
```

---

## Notes and Best Practices
1. Ensure dataset images are binary (white foreground, black background).
2. Resize images to a uniform size before feature extraction.
3. Adjust dataset-specific parameters (`+2` indexing offset) to match your dataset structure.
4. Use MATLAB's debugging tools to verify intermediate outputs.

---

## Troubleshooting
1. **Indexing Errors**:
   - Verify dataset structure.
   - Update the indexing logic (`+2`) as required.
2. **Low Recognition Accuracy**:
   - Check image preprocessing and ensure binary images are correctly formatted.
3. **Visualization Issues**:
   - Ensure `regionprops` returns valid properties for all images.

---

## Contact
For additional help or feedback:
- **Email**: support@example.com
- **GitHub Repository**: [EllipseFitAllignment](https://github.com/your-repo/EllipseFitAllignment)
