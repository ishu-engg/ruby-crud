# Ruby CRUD App with Typesense Integration

This is a Ruby on Rails application that implements CRUD operations and integrates with Typesense for fast, typo-tolerant search functionality.

## Prerequisites

* Ruby version: 3.1.0 (or your specific version)
* Rails version: 7.2.1 (or your specific version)
* PostgreSQL
* Typesense

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-username/ruby_crud.git
   cd ruby_crud
   ```

2. Install dependencies:
   ```
   bundle install
   ```

3. Set up the database:
   ```
   rails db:create
   rails db:migrate
   ```

4. Set up Typesense:
   - Install Typesense: [Typesense Installation Guide](https://typesense.org/docs/guide/install-typesense.html)
   - Start Typesense server

5. Configure Typesense:
   - Open `config/initializers/typesense.rb`
   - Update the configuration with your Typesense server details and API key

## Running the Application

1. Start the Rails server:
   ```
   rails server
   ```

2. Access the application at `http://localhost:3000`

## API Endpoints

- GET `/tasks` - List all tasks
- GET `/tasks/:id` - Get a specific task
- POST `/tasks` - Create a new task
- PUT `/tasks/:id` - Update a task
- DELETE `/tasks/:id` - Delete a task

## Typesense Integration

- POST `/create_typesense_collection` - Create Typesense collection
- GET `/check_typesense_connection` - Check Typesense connection status

## Running Tests

```
rails test
```

## Deployment

Add deployment instructions specific to your setup.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License.