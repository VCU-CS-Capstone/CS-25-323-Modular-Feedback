-- Create the 'features' table
CREATE TABLE features (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create the 'feature_attributes' table (for reference)
CREATE TABLE feature_attributes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Create the 'agents' table
CREATE TABLE agents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the 'feedback' table with the necessary rating fields
CREATE TABLE feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    agent_id INT NOT NULL,
    feature_id INT NOT NULL,
    overall_rating DECIMAL(3, 1) NOT NULL,
    ease_of_use DECIMAL(3, 1) NOT NULL,
    flexibility DECIMAL(3, 1) NOT NULL,
    reliability DECIMAL(3, 1) NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (agent_id) REFERENCES agents(id),
    FOREIGN KEY (feature_id) REFERENCES features(id)
);

-- Insert sample data into the 'features' table
INSERT INTO features (name, description) VALUES
('Online Banking', 'Access your accounts and perform transactions online'),
('Mobile App', 'Bank on-the-go with our mobile application'),
('Credit Card Rewards', 'Earn points and cashback on your purchases'),
('Customer Support', '24/7 customer service and support'),
('Loan Application', 'Apply for loans online or in-branch');

-- Insert sample data into the 'agents' table
INSERT INTO agents (name, email) VALUES
('John Doe', 'john.doe@example.com'),
('Jane Smith', 'jane.smith@example.com'),
('Bob Johnson', 'bob.johnson@example.com');

-- Insert sample data into the 'feedback' table
INSERT INTO feedback (agent_id, feature_id, overall_rating, ease_of_use, flexibility, reliability, comment) VALUES
(1, 1, 9.5, 9.0, 8.0, 9.0, 'Great online banking experience!'),
(2, 1, 7.0, 6.5, 7.0, 6.0, 'Easy to use, but could use some improvements'),
(3, 2, 9.5, 9.0, 8.5, 9.0, 'The mobile app is fantastic!'),
(1, 2, 6.0, 5.5, 7.0, 6.0, 'App is okay, but crashes sometimes'),
(2, 3, 8.5, 8.0, 9.0, 8.5, 'Love the rewards program'),
(3, 3, 9.5, 9.0, 9.5, 9.0, 'Best rewards in the industry'),
(1, 4, 4.5, 4.0, 5.0, 4.5, 'Long wait times for customer support'),
(2, 4, 7.5, 7.0, 7.5, 7.0, 'Support team was very helpful'),
(3, 5, 6.5, 6.0, 6.5, 7.0, 'Loan application process is average'),
(1, 5, 9.0, 8.5, 9.0, 9.0, 'Quick and easy loan application');