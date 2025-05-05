# 📊 Employee Retention Analysis

## 🚀 Project Overview
This project explores the key drivers behind employee turnover using real-world **Glassdoor reviews data**. It combines **SQL** and **Power BI** for business intelligence and adds **machine learning models in Python** to predict employee attrition. The study focuses on identifying actionable insights and building a predictive pipeline that HR teams can interpret and use.

---

## 🛠️ Tools & Technologies
- **SQL (MySQL Workbench)** – Data cleaning, transformation, and querying
- **Power BI** – Interactive dashboard creation with DAX measures
- **Python (Jupyter Notebook)** – Feature engineering, modeling, and evaluation
- **Libraries**: pandas, matplotlib, seaborn, scikit-learn, xgboost

---

## 📂 Dataset
- Source: Glassdoor-style synthetic dataset of tech employee reviews
- Key Columns:
  - `company`, `current` (employee status)
  - Ratings: `overall_rating`, `work_life_balance`, `career_opp`, `senior_mgmt`, `comp_benefits`
  - Text: `pros`, `cons`
  - Derived: `tenure`, `turnover`, `company_size`

---

## 🔍 Key Business Questions Answered
- What factors influence company reviews across different company sizes?
- Do senior employees value work-life balance more than salary?
- Are career growth opportunities more valued in startups?
- Why do employees leave companies?
- How have satisfaction ratings changed over time?

---

## 📈 Power BI Dashboard Highlights
- Interactive filters for company size, tenure, and satisfaction factors
- Key trends in employee ratings over time
- Segmented analysis of priorities by seniority and company type
- Turnover rate and average employee tenure visualized
- 🔗 [Dashboard Preview](https://i.ibb.co.com/DZXJhh0/Employee-Retention-Report.jpg)

---

## 📊 Final Power BI Dashboard
The final dashboard provides an **interactive view** of employee retention trends, priorities, and insights.

![](https://i.ibb.co.com/DZXJhh0/Employee-Retention-Report.jpg)

---

### 📊 Model Performance Comparison

| Model              | Accuracy | Precision | Recall | F1-Score |
|-------------------|----------|-----------|--------|----------|
| Logistic Regression | 67%     | 67%       | 67%    | 67%      |
| Random Forest       | 78%     | 76%       | 87%    | 81%      |
| XGBoost             | 80%     | 76%       | 91%    | 82%      |
| Gradient Boosting   | 79%     | 76%       | 89%    | 82%      |
| MLP Classifier      | 77%     | 74%       | 89%    | 81%      |
| **Decision Tree** ✅| 80%     | 76%       | 91%    | 82%      |


> ✅ **Decision Tree** was selected for deployment due to its strong performance and interpretability for HR stakeholders.

---

## 💡 Key Insights & Business Recommendations
- 📉 **Work-Life Balance & Leadership**: Rated lowest. Focus on improving flexibility and management communication.
- 💼 **Career Growth vs Salary**: Mid-level employees in startups prioritize growth ~50%, similar to salary.
- 🚪 **Why They Leave**: Poor senior management (2.98) is the most cited issue.
- ⏳ **Retention Risk**: Employees with 0–2 years tenure are most likely to leave.
- 🎯 **Strategy Suggestions**:
  - Launch leadership development programs.
  - Introduce career progression paths for mid-level staff.
  - Incentivize longer tenure via loyalty or bonus schemes.

---

## 🔮 Future Enhancements
- Real-time API integration for live review updates
- Sentiment analysis on pros/cons using NLP
- Deploy prediction model as a Flask web app
- Automate insights alerts using Power Automate or Python scripts

---

## 👨‍💻 Author

**Kazi Mahmudul Hasan**   
🔗 GitHub: [Kazi-Mahmudul](https://github.com/Kazi-Mahmudul)  
🔗 LinkedIn: [Kazi-Mahmudul-Hasan](https://www.linkedin.com/in/kazi-mahmudul-hasan)
