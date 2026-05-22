# 🎬 MyRottenPotatoes

A clean and modern Ruby on Rails web application for managing and discovering movies. Users can create, edit, delete, filter, and sort movies with ease. Built with a beautiful, responsive user interface.

## 🌟 Features

- ✅ **Create Movies** - Add new movies with title, rating (0-5), description, and release date
- 📋 **View All Movies** - Browse all movies in a visually organized card layout
- 🔍 **Search by Rating** - Filter movies by rating (0 to 5 stars)
- 📊 **Sort Movies** - Sort by title, rating, or release date (ascending/descending)
- ✏️ **Edit Movies** - Update movie information with pre-filled forms
- 🗑️ **Delete Movies** - Remove movies with confirmation dialog
- 🎨 **Beautiful UI** - Clean, modern, responsive interface with smooth animations
- 💬 **Flash Messages** - Success and error notifications with animations
- 🔒 **Data Validation** - Prevents empty fields, duplicates, and invalid ratings
- 🧪 **BDD Testing** - Cucumber + Capybara for behavior-driven development (NEW!)
- 🔎 **TMDb Search** - Search for movies in The Movie Database (NEW!)

## 🧪 BDD Implementation

This project includes BDD tests with Cucumber covering the following behaviors:

- TMDb search sad path (movie not found)
- Adding and sorting movies by title (imperative and declarative)
- Filtering movies by selected ratings
- Sorting movies by release date

Full documentation, scenario descriptions, step definitions reference, and run commands:
- 📄 [BDD.md](BDD.md) - BDD documentation and instructions

Run all scenarios with:

```bash
bundle exec cucumber
```

### Full CRUD Implementation

This project implements a **complete CRUD** (Create, Read, Update, Delete) system:

- **CREATE** ✅ - Users can create new movies with validation
- **READ** ✅ - Users can view all movies and individual movie details
- **UPDATE** ✅ - Users can edit existing movies with pre-filled forms
- **DELETE** ✅ - Users can remove movies with confirmation dialogs

## 🛠️ Tech Stack

- **Ruby**: 3.0.2
- **Rails**: 7.1.6
- **Database**: SQLite3
- **Frontend**: HTML5, CSS3, JavaScript (Turbo)
- **UI**: Responsive design with gradients and animations

## 📋 Requirements

- Ruby 3.0.2 or higher
- Rails 7.1.6
- SQLite3
- Bundler
- Node.js (for asset compilation)

## 🚀 Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/anaareiis/My-Rotten-Potatoes
cd myrottenpotatoes
```

### 2. Install Dependencies

```bash
# Install Ruby gems
bundle install

# Install JavaScript dependencies (if needed)
bundle exec rails javascript:install:esbuild
bundle exec rails css:install:bootstrap
```

### 3. Setup Database

```bash
# Create and migrate the database
bundle exec rails db:create
bundle exec rails db:migrate

# (Optional) Load sample data
bundle exec rails db:seed
```

## ▶️ Running the Application

### Development Server

Start the Rails server:

```bash
bundle exec rails server
```

Or use the shorter command:

```bash
rails s
```

The application will be available at: **http://localhost:3000**

### With Assets Watcher

For automatic asset recompilation during development:

```bash
./bin/dev
```

## 📖 Usage Guide

### Viewing Movies

1. Navigate to the home page: `http://localhost:3000`
2. All movies are displayed as cards with:
   - Movie title
   - Rating (⭐ 0-5 stars)
   - Description preview
   - Release date

### Adding a New Movie

1. Click the **"➕ Add New Movie"** button
2. Fill in the form:
   - **Title** - Movie name (required, must be unique)
   - **Rating** - Select 0-5 stars (required, integer only)
   - **Description** - Plot or details (required)
   - **Release Date** - Use the date picker (required)
3. Click **"💾 Save Movie"**
4. A success message appears and you're redirected to the movie list

### Filtering Movies

1. Use the **"Filter by Rating"** dropdown
2. Select a rating (0-5 stars) or "All Ratings"
3. Click **"Apply Filters"**
4. Only movies with that rating will be displayed

### Sorting Movies

1. Use the **"Sort by"** dropdown with options:
   - Newest First (default)
   - Title (A-Z / Z-A)
   - Rating (High to Low / Low to High)
   - Release Date (Newest / Oldest)
2. Click **"Apply Filters"**
3. Movies will be reordered accordingly

### Combining Filter & Sort

- Use both dropdowns together
- Click **"Apply Filters"** to apply both simultaneously
- Your selections are preserved in the URL

### Viewing Movie Details

1. Click on any movie title from the list
2. View the complete movie information:
   - Full description
   - Exact rating
   - Release date
3. Available actions:
   - **✏️ Edit** - Modify movie information
   - **🗑️ Delete** - Remove the movie (with confirmation)
   - **↩️ Back to Movies** - Return to the list

### Editing a Movie

1. From the movie detail page, click **"✏️ Edit"**
2. The form is pre-filled with current information
3. Update any fields as needed
4. Click **"💾 Update Movie"**
5. Success message displays and you return to the movie list

### Deleting a Movie

1. From the movie detail page, click **"🗑️ Delete"**
2. Confirm the deletion when prompted
3. Movie is removed and you return to the list
4. Success message confirms the deletion

## 🔒 Data Validation

The application includes comprehensive validation to ensure data integrity:

### Back-end Validation (Rails Model)
- **Title**: 
  - Required, must be unique (case-insensitive)
  - Length: 2-200 characters
  - Shows friendly error if duplicate

- **Rating**: 
  - Required
  - Must be an integer (no decimals)
  - Range: 0-5 stars only
  - Clear error message: "must be an integer between 0 and 5"

- **Description**: 
  - Required
  - Length: 10-1000 characters
  - Shows error if too short or too long

- **Release Date**: 
  - Required
  - Cannot be in the future
  - Cannot be before 1800
  - Validates reasonable date range

### Front-end Validation (HTML5 & JavaScript)
- **required attributes** - Prevents form submission with empty fields
- **minlength/maxlength** - Browser enforces character limits
- **date input with max** - Prevents selecting future dates
- **Character counter** - Real-time feedback (10-1000 characters)
- **Visual indicators** - Color changes based on character count:
  - 🔴 Red: Too few characters (< 10)
  - 🟢 Green: Valid character count (10-900)
  - 🟡 Yellow: Approaching limit (900-1000)

### Error Handling
- Clear, descriptive error messages
- Error messages displayed in red box on form
- Full validation messages explain what's wrong
- Prevents invalid data from being saved

## 📁 Project Structure

```
myrottenpotatoes/
├── app/
│   ├── controllers/
│   │   └── movies_controller.rb
│   ├── models/
│   │   └── movie.rb
│   └── views/
│       └── movies/
│           ├── index.html.erb
│           ├── new.html.erb
│           ├── edit.html.erb
│           └── show.html.erb
├── config/
│   ├── routes.rb
│   └── database.yml
├── db/
│   └── migrate/
├── README.md
└── Gemfile
```

## 🐛 Troubleshooting

### Gems not installing
```bash
bundle install --no-cache
```

### Database issues
```bash
# Reset the database
bundle exec rails db:drop db:create db:migrate
```

### Port 3000 already in use
```bash
# Run on a different port
bundle exec rails server -p 3001
```

### Assets not loading
```bash
bundle exec rails assets:precompile
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

Created with ❤️ by Ana Luísa Reis Nascente (211045688)

## 📧 Support

For issues, questions, or suggestions, please open an issue in the repository.
