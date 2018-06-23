# gocli
Command Line Interface (CLI) program which simulates GO-JEK ordering system. Made with Ruby without any Gems.

**GO-CLI Application**

This application was made with one control class scheme as the original app controls everything on their main server, whilst making "World" the main workflow class.

Dividing workload on element classes that could process their own task, Driver with moving and calculating prices, whilst User with saving their own order history. Elemen classes process their own task on app, whilst server decides which driver is nearby, assigning driver, and tranferring information.

The order log are not formatted to secure the data (it would be harder to modify). And the world data log are formatted based on the variables abbreviations to make the developers easier on modifying the world data.

Set-up: 
open CMD, run by using

ruby main.rb

Directory settings may vary based on computer
add Dir.chdir(Dir.pwd+"/extended_directory") to User.rb and World.rb

## Structure
``
--bin
main.rb
README.txt
text format guide.txt
world_data.txt
  --class
  Driver.rb
  User.rb
  user_log.txt
  World.rb
``

## Functions:
  main.rb: to initiate game, importing libraries and generating World class

  World.rb: main workflow class, handles almost everything that happened. Using subclasses User and Driver as element classes to deliver results that could be processed on element classes. Class World are similar to the app which processes most of the process themselves.

  User.rb: User class, defining user as an object and an element in the World class which moves corresponding to the driver (if order were taken). Handles order history loading and saving.

  Driver.rb: Driver class, defining driver as an object and an element in the World class which moves corresponding to the users (if order were taken). Handles price estimating, pathfinding and moving processes.

## Assumptions
1. Order could be given more than one
2. Coordinates are always valid (1..n)
3. Input are always validated
4. Every spaces are usable roads (no obstacles)
5. Driver placement can overlap
6. Zigzag routes are preferables
7. Order history only records orders
