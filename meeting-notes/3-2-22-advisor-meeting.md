# Advisor Meeting 3-2-22

Kaushik, John, Julia, Ben, Fatema, Morgan

## Notes

- Fixing overfitting
  - while training, change the scanrio to create realistic variations in the sampling
  - increase the depth of the layers
- inputs have to be normalized
  - if the antennas are at varrying distances, csi amplitudes should be normalized because we dont care about the amplitude
- try dynamic gestures, it causes more change to CSI

## Action Items

- train at different times of day in different environments
- shuffle the input so its not all empties then all gestures
- re split the sign-fi data 70-20-10 train-validation-test and actually run data through their model to confirmm it actually works
- normalize the data
