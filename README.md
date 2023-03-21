# Scratch Card Game
This project is focused on building a networked game for scratch cards, where players can play a traditional button-counting game but with the added twist of using six cards instead of three. The game will be built using Ruby on Rails framework for web development.

## Requirements
In order to run this project, you will need:

- Ruby on Rails (version 6.1 or higher)
- A web server such as Apache or Nginx
- A database management system such as MySQL or SQLite3

## Getting Started
1. To get started with this project, you can clone the repository to your local machine using the following command:

```
git clone https://github.com/tuanle03/Scratch_Cards.git
```

2. Once you have cloned the repository, navigate to the project directory and install the necessary dependencies by running:

```
bundle install
```

3. Next, you will need to set up the database by running the following commands:

```
rails db:create
rails db:migrate
```

4. Finally, start the web server by running:

```
rails server
```

5. You should now be able to access the game by visiting `http://localhost:3000` in your web browser.

## Project Structure
The project is structured as follows:

- `app/controllers` contains the controllers for the game logic.
- `app/models` contains the models for the game objects such as players and cards.
- `app/views` contains the views for rendering the game interface.
- `config/routes.rb` contains the routing configuration for the game.

The project also includes a spec directory containing the tests for the project.

## Contributing
If you find any issues with the code in this repository or would like to contribute improvements, feel free to open an issue or submit a pull request.
