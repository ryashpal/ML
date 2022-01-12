# Studying sepsis by modelling patient mortality

## Aim

## Methodology

### Data used in this analysis

The in-house data at Alfred Health and the MIMIC III data both represented in OMOP schema will be used for this analysis. As it is a multi-centre study, usage of OMOP is preferred to make the analysis interoperable. It will also help in validating the models built on MIMIC schema on in-house Alfred data and vice versa.

## Selection criteria applied on the data

Since we are focussing on the sepsis caused by bloodstream infections in adult patients, the following selection criteria will be applied;
* Include only adult patients (age > 16).
* Include patients with good coverage.

## Establishing an episode representing each observation
Each hospital stay will be defined as an episode for mortality prediction, as we are interested in the mortality due to sepsis acquired during an hospital stay where there is an elevated chance of picking up AMR pathogens. We will also be exploring the possibility of using entire EHR data of a patient for predicting mortality for the same patient cohort.

## Defining target for the prediction
As we are focussed on studying the mortality caused by hospital acquired AMR infections, we would like to obtain the factors affecting the patient mortality. This mortality can be covering a wide range of time-duration as it will let us study the factors causing short-term mortality, medium-term mortality, and long-term mortality all of which are of interest for this project. However, mortality is available at the admission table in the MIMIC data. Therefore, we need to obtain the date/time of the death from the admissions table and use the ICU discharge time to determine if the patient survived n-days post discharge from a given ICU stay. Similar data manipulation might be required for Alfred schema as well.

## Extracting and representing features
We aim to identify the physiological and laboratory measurements that are associated with higher mortality in patients with sepsis. Hence, in this study we will be including routinely collected variables at the ICU along with attributes that are considered while calculating sequential organ failure assessment (SOFA) score. The representation of these features is mainly dictated by the machine learning algorithm that will be employed. In general, traditional machine learning algorithms require data to be represented in a one dimensional array with rows containing different attributes of an observation (an episode) made up of different such observations along the columns. This requires summarising the time varying measurements as usually there will be more than one per episode. It can be performed by calculating minimum, maximum, first, last, mean, mode, standard deviation, variance, range, kurtosis, and skewness from the measurements. On the other hand, a three dimensional data matrix (observation * measurement * time series) will be formed for the deep learning based methods as they can handle multi-dimensional data.

## Determining data window
Normally, shorter data windows are preferred in the application for early warning systems or for triage purposes. But, the primary focus of this study is at discovering the physiological and other host related attributes that are associated with patient mortality in the case of Sepsis caused by bloodstream infections. Hence, we will be including all the available data acquired during a hospital stay in this analysis.

## Data anomalies handling
Anomalies in the data will be detected in an unsupervised manner using different methods and the outputs are combined to form an ensemble score using Item Response Theory (IRT). An appropriate cutoff value of the ensemble score will be arrived at and used to flag the anomalous data that will be removed from the cohort.

## Data imbalance handling
The positive dataset will be identified by selecting episodes with lab results having a bloodstream infection and later diagnosed with Sepsis. An equal number of episodes will be selected with a negative bloodstream infection detection in the lab investigation to make a balanced dataset.

## Choosing performance metrics
As we have a balanced dataset, the area under the receiver operating characteristic curve (AUROC) will be used as the primary metric to assess the performance of the model. Many of the benchmarking studies use the same metric, hence it is convenient if we choose it in our work.

## Selection of machine learning algorithms
We will be using both conventional machine learning models with a wide range of algorithms such as Naive Bayes, Logistic Regression, Random Forest, K Nearest Neighbours as well as Deep Learning models of different topologies including ANN, LSTM and transformer based architectures.

## Validating and benchmarking the results
An independent set of data will be set aside for validation to avoid any data leakage which will be used to measure model performance on unseen data. The models built on one source will be put to test by running them on the data from a different source to determine their generalization capability.

## Interpretation techniques used for the models
Certain machine learning models have an inherent ability to rank the input variables, which will be exploited to obtain feature important measures. For all other models, an external method called SHapley Additive exPlanations (SHAP) will be used to obtain the important features and other related analysis.
