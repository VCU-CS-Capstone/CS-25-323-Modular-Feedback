-- Create the 'features' table
CREATE TABLE features (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create the 'rating_scale' table
CREATE TABLE rating_scale (
    id INT PRIMARY KEY,
    description VARCHAR(50) NOT NULL,
    icon VARCHAR(50) NOT NULL,
    color VARCHAR(7) NOT NULL
);

-- Create the 'feature_attributes' table
CREATE TABLE feature_attributes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Create the 'feature_attribute_ratings' table
CREATE TABLE feature_attribute_ratings (
    feature_id INT NOT NULL,
    attribute_id INT NOT NULL,
    rating_id INT NOT NULL,
    PRIMARY KEY (feature_id, attribute_id),
    FOREIGN KEY (feature_id) REFERENCES features(id),
    FOREIGN KEY (attribute_id) REFERENCES feature_attributes(id),
    FOREIGN KEY (rating_id) REFERENCES rating_scale(id)
);

-- Create the 'agents' table
CREATE TABLE agents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the 'feedback' table
CREATE TABLE feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    agent_id INT NOT NULL,
    feature_id INT NOT NULL,
    rating_id INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (agent_id) REFERENCES agents(id),
    FOREIGN KEY (feature_id) REFERENCES features(id),
    FOREIGN KEY (rating_id) REFERENCES rating_scale(id)
);

-- Insert data into the 'rating_scale' table
INSERT INTO rating_scale (id, description, icon, color) VALUES
(-2, 'Very Dissatisfied', 'fa-thumbs-down', '#F44336'),
(-1, 'Dissatisfied', 'fa-thumbs-down', '#FF9800'),
(0, 'Neutral', 'fa-meh', '#FFC107'),
(1, 'Satisfied', 'fa-thumbs-up', '#8BC34A'),
(2, 'Very Satisfied', 'fa-thumbs-up', '#4CAF50');

-- Insert data into the 'feature_attributes' table
INSERT INTO feature_attributes (name, description) VALUES
('Ease of Use', 'How easy it is to use the feature'),
('Flexibility', 'How flexible or adaptable the feature is'),
('Reliability', 'How reliable or bug-free the feature is');

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
INSERT INTO feedback (agent_id, feature_id, rating_id, comment) VALUES
(1, 1, 2, 'Great online banking experience!'),
(2, 1, 1, 'Easy to use, but could use some improvements'),
(3, 2, 2, 'The mobile app is fantastic!'),
(1, 2, 0, 'App is okay, but crashes sometimes'),
(2, 3, 1, 'Love the rewards program'),
(3, 3, 2, 'Best rewards in the industry'),
(1, 4, -1, 'Long wait times for customer support'),
(2, 4, 1, 'Support team was very helpful'),
(3, 5, 0, 'Loan application process is average'),
(1, 5, 2, 'Quick and easy loan application');

-- Insert sample data into the 'feature_attribute_ratings' table
INSERT INTO feature_attribute_ratings (feature_id, attribute_id, rating_id) VALUES
(1, 1, 2), (1, 2, 1), (1, 3, 2),
(2, 1, 1), (2, 2, 2), (2, 3, 0),
(3, 1, 2), (3, 2, 1), (3, 3, 1),
(4, 1, 1), (4, 2, 0), (4, 3, 1),
(5, 1, 0), (5, 2, 1), (5, 3, 2);

-- Alter the 'feedback' table to store individual ratings for each attribute
ALTER TABLE feedback
ADD COLUMN overall_rating DECIMAL(3, 1) NOT NULL,
ADD COLUMN ease_of_use DECIMAL(3, 1) NOT NULL,
ADD COLUMN flexibility DECIMAL(3, 1) NOT NULL,
ADD COLUMN reliability DECIMAL(3, 1) NOT NULL,
DROP COLUMN rating_id;  -- You no longer need the `rating_id` field