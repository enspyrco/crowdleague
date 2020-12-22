0 - Introduction 
=================

Note that the sections are numbered but the items within each section are dot points rather than a numbered list. The two sections should be done in order, but within each section it's probably a good idea to jump around and expect to do multiple passes.

1 - Planning in consultation with stakeholders 
===============================================

-   Replace *Section* below with the section name, eg. Auth

-   Create in Drive - a folder called "*Section*: Sections Planning (CL)" in "Sections Planning (CL)".  In the folder: 

    -   a Google doc called "Use Cases < *Section* (CL)" that will hold just a list of Use Cases, so we have a short, easy to read and think about, list that is the definitive set of use cases

        -   short, clear names → balance brevity with clarity 

-   Create an Asana Project called "> *Section*" 

    -   add a link to the relevant "Sections Planning" Google Drive folder 

    -   add a link to The Process google doc 

-   Start a Discussion in Asana called "Planning Discussion", tag all stakeholders and ask for input on: 

    -   the use cases 

    -   ... 

    -   anything anyone wants to add 

-   Do a design review 

    -   look for apps solving similar problems in interesting ways 

    -   write some notes about the parts you think are done well 

    -   search for inspiration in collections of cool designs (eg. [Dribbble](https://dribbble.com/), [Uplabs](https://www.uplabs.com/))

-   Complete use cases for level 1

2 - Build everything around the use-case 
=========================================

> large use cases can be split into parts 

> each use case needs a short but identifying code name 

For each use-case there will be three types of digital goodness:

-   Asana task 

-   GitHub Issue 

-   Google Docs (x3) 

    -   Models 

    -   User Flow 

    -   Sequence Diagram

Inside Google Drive Folder "*Section*: Sections Planning (CL)", create:

-   A Models file

      -   Create a UML  - ([example](https://docs.google.com/drawings/d/1-X-aZdVrsuFItxlwkJqusOINdk0kYb9dl3fgLTQVz94/template/preview?usp=drive_web))
      
      -   Add title - "Models < *Section* (CL)"

-   A Drive folder for each use case, called "x. *Use Case* < *Section* (CL)" and in that folder, create:

    -   A User Flow: (see: [User flow is the new wireframe](https://uxdesign.cc/when-to-use-user-flows-guide-8b26ca9aa36a) & [The How (and Why) of User Flows](https://uxdesign.cc/the-how-and-why-of-user-flows-85df776a1e2))

        1. Create a folder to hold all files needed to create a user flow diagram
            - After creating the user flow diagram, all files in this folder don't need to be looked at. So keeping them separate will reduce clutter and make it easier to look for the files we need to look at when creating github issues and coding! 
            - Add title: "User Flow Pieces < x. *Use Case*  < *Section* (CL)"

        2. Inside "User Flow Pieces" folder, create a doc to outline action steps for the use case. 
            - Add title: "Action steps < User Flow Pieces < x. *Use Case* < *Section* (CL)"
            - Add template to doc: 
                -   A leaguer who...
                    -   (context) 
                -   wants to...
                    -   (goal) 
                -   so they...
                    -   (action steps)
            - After adding action steps, create an "input task"[3] in asana

        3. Inside "User Flow Pieces" folder, create lofi wireframe
            - Sketch lofi wireframe on paper
            - Create a google drawing to get input on sketch
                - Add title: "Lofi Sketch <  User Flow Pieces < x. *Use Case* < *Section* (CL)"
            - Take a photo and upload it to the google drawing doc from the previous step
            - Add any helpful comments, e.g reasoning for design decisions, specific questions about design
            - Create an "input task"[3] in asana
            - When all conversations are resolved, Create Hifi wireframe!

        4. Inside "User Flow Pieces" folder, create Hifi wireframe
            - Create Hifi wireframe using Adobe XD
            - Inside "user flow folder"[2] , create a google drawing to get input on wireframe
                - Add title: "Hifi wireframe < User Flow Pieces < x. *Use Case* <  *Section* (CL)"
            - Export any screens created in XD and upload them to google drawing doc
            - Add any helpful comments, e.g reasoning for design decisions, specific questions about design
            - Create an "input task"[3] in asana
            - When all conversations are resolved, Create User Flow Diagram!

        5. Inside "x. *Use Case* < *Section* (CL)" folder, create a User Flow Diagram
            - Create a google presentation file
              - Add title: "User Flow Presentation < x. *Use Case* < *Section* (CL)"
            - Export any screens created in XD and add them to a slide in the google presentation
            - Add the relevant action step to each slide
            - Create an "input task"[3] in asana

    -   A Sequence Diagram ([tutorial](https://creately.com/blog/diagrams/sequence-diagram-tutorial/), examples: [oauth2](https://developers.google.com/identity/protocols/oauth2?csw=1))  

        - Inside "x. *Use Case* < *Section* (CL)" folder, create a sequence diagram

        -   Add title - "Sequence Diagram < x. *Use Case*  < *Section* (CL)"

        -   See [Sequence Diagram Legend](https://docs.google.com/drawings/d/1KHo0M8I2elC-vrY2kQYZ38CgU4O2P9hkD4BFeoDcxSY/edit) 

        -   Decide on widget/action/middleware names

-   In Asana, create:

    -   A task for each use case, linked to the GitHub issue and Google folder 


- In github, create:

    -   An issue for each use case:

        1.  Create a tracking issue

            - add the "tracking" label

            - Add a title "section_name use_case_number: use_case_name"

            - in the description, break down the use case into a checklist of tasks (sub issues)

        2.  For each task in tracking issue, create an issue and link its issue number

        3.  Add all created issues to appropriate github projects

- Add links back and forth between the Task, Issue & Doc

-   Folders for tests (use the code-name for the use-case) 

-   Draft PR and request feedback on any missing tests 

-   TDD 

-   PR

Notes on the various tools 
===========================

-   Google docs are great for creating longer, more complex documents (eg. with diagrams and a TOC)

-   Asana Discussions are great for capturing Q&A type conversations (a bit like StackOverflow)


Key
====

1. "IS" : input session

2. "user flow folder": folder created in user flow step 1, titled: "x. *Use Case* < User Flow Pieces < *Section* (CL)"

3. "input task": 
    1. Create a task in Asana with title "IS [1]: *title of Google file*" and:
        - Add a link to the google file in the task description
        - Move the task to the "Open for input" column
        - Add a due date of tomorrow at 5:00pm
        
    2. Hold an RTC to discuss the file. This is to get all teammates on the same page, which makes it easier for everyone to give more valuable input. 
        - RTC can be held during day of creation, or after standup next day.
        - At end of RTC, inform team about input sessions due date 

    3. Finalise file:
        - Resolve any conversations (use RTCs if necessary)
        - At due date, declare the doc sealed
