# Google Analytics Customer Revenue Prediction

### Description:
The 80/20 rule has proven true for many businesses–only a small percentage of customers produce most of the revenue. As such, marketing teams are challenged to make appropriate investments in promotional strategies.

RStudio, the developer of free and open tools for R and enterprise-ready products for teams to scale and share work, has partnered with Google Cloud and Kaggle to demonstrate the business impact that thorough data analysis can have.

In this competition, you’re challenged to analyze a Google Merchandise Store (also known as GStore, where Google swag is sold) customer dataset to predict revenue per customer. Hopefully, the outcome will be more actionable operational changes and a better use of marketing budgets for those companies who choose to use data analysis on top of GA data

### Evaluation:
Root Mean Squared Error (RMSE)

Submissions are scored on the root mean squared error. RMSE is defined as:

![alt text](https://cdn-images-1.medium.com/max/1600/1*9hQVcasuwx5ddq_s3MFCyw.gif)

where y hat is the natural log of the predicted revenue for a customer and y is the natural log of the actual summed revenue value plus one.

Submission File

For each *fullVisitorId* in the test set, you must predict the natural log of their total revenue in *PredictedLogRevenue*. The submission file should contain a header and have the following format:

|fullVisitorId|PredictedLogRevenue|
|-------------|-------------------|
|000000025967871401|0|
|0000000259678714014|0|
|0000049363351866189|0|
|0000053049821714864|0|
|etc.|...|

### Timeline:
* November 8, 2018 - Entry deadline. You must accept the competition rules before this date in order to compete.
* November 8, 2018 - Team Merger deadline. This is the last day participants may join or merge teams.
* November 15, 2018 - Final submission deadline.

All deadlines are at 11:59 PM UTC on the corresponding day unless otherwise noted. The competition organizers reserve the right to update the contest timeline if they deem it necessary.
