# Fin Save

## Overview

Fin Save is a full-stack Flutter application designed for efficient personal finance management. It empowers users to track income, expenses, savings, and budgets seamlessly through an intuitive interface. Whether you're planning your financial future or monitoring daily transactions, Fin Save provides the tools you need for financial success.

## Features

- **User Authentication:**
  - Secure email and password authentication.
  - Persistent authentication state.

- **Financial Management:**
  - Track income and expenses with detailed transaction records.
  - Categorize transactions for better financial insights.

- **Budget Planning:**
  - Set monthly spending limits and monitor expenditures.
  - Visualize spending trends with customizable graphs.

- **Savings Analysis:**
  - Monitor savings goals and progress with interactive charts.
  - Plan for long-term financial objectives.

- **Notification System:**
  - Real-time alerts for transaction updates and account activities.
  - Customizable notification preferences.

- **Settings and Personalization:**
  - Customize app themes and user settings.
  - Manage profile details and preferences.

- **Settings Screen:**
  - **Notification Preferences:**
     -Allows users to manage notification settings, including toggling notifications on/off for different types of activities such as transaction alerts or reminders.

  - **Profile Management:**
     -Provides options to update user profile details such as name, email address, and profile picture.

  - **Security Settings:**
     -Includes options for managing account security, such as changing passwords or enabling two-factor authentication for added security.

  - **Language and Region Settings:**
     -Users can select preferred languages and regions to customize the app's localization settings..

## Running Locally

To run Fin Save locally on your machine you should first clone the repository
After cloning this repository, follow these steps to set up and run the Fin Save app:

1. **Set Up MongoDB:**
   - Create a MongoDB project and cluster.
   - Obtain the MongoDB URI and replace it with yours in `server/index.js`.

2. **Configure Frontend:**
   - Head to lib/constants/global_variables.dart file, replace with your IP Address.

3. **Run Server Side:**
   \`\`\`bash
   cd server
   npm install
   npm run dev  # for continuous development
   # OR
   npm start    # to run script once
   \`\`\`

4. **Run Client Side:**
   \`\`\`bash
   flutter pub get
   flutter run
   \`\`\`

## Tech Stack

### Server Side
- Node.js
- Express
- Mongoose
- MongoDB
- Cloudinary

### Client Side
- Flutter
- Provider
