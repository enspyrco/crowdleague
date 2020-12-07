0 - Introduction 
=================

Note that the sections are numbered but the items within each section are dot points rather than a numbered list. The two sections should be done in order, but within each section it's probably a good idea to jump around and expect to do multiple passes.

1 - Planning in consultation with stakeholders 
===============================================

-   Replace *Section* below with the section name, eg. Auth

-   Use the next available Section number (denoted x. below)

-   Create in Drive - a folder called "x. *Section*: Sections Planning (CL)" in "Sections Planning (CL)".  In the folder: 

    -   a Google doc called "0 - Use Cases < *Section* (CL)" that will hold just a list of Use Cases, so we have a short, easy to read and think about, list that is the definitive set of use cases

        -   short, clear names → balance brevity with clarity 

-   Create an Asana Project called "x. *Section*" 

    -   add a link to the relevant "Sections Planning" Google Drive folder 

    -   add a link to The Process google doc 

-   Start a Discussion in Asana called "Planning Discussion", tag all stakeholders and ask for input on: 

    -   the use cases 

    -   ... 

    -   anything anyone wants to add 

-   Do a design review 

    -   look for apps solving similar problems in interesting ways 

    -   write some notes about the parts you think are done well 

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

Create: 

-   An Asana task for each use case, linked to the GitHub issue and Google doc (see below) 

-   A Drive folder for each use case, called "x. *Use Case* - *Section* (CL)" and in that folder, a Google Doc for each use case: 

    -   Models 

        -   "x. *Use Case* < Models < *Section* (CL)"
        
        -   Google Drawing 

        -   UML Diagram ([example](https://docs.google.com/drawings/d/1-X-aZdVrsuFItxlwkJqusOINdk0kYb9dl3fgLTQVz94/template/preview?usp=drive_web)) 

    -   A User Flow 

        1. Create a folder to hold all files needed to create a user flow
            - Add title: "x. *Use Case* - User Flow files - *Section* (CL)"

        2. Inside folder created in step 1, create a doc to outline action steps for the use case. 
            - Add title: "x. *Use Case* - User Flow - *Section* (CL)"
            - Add template to doc: 
                -   A leaguer who...
                    -   (context) 
                -   wants to...
                    -   (goal) 
                -   so they...
                    -   (action steps)
            - After adding action steps, create "input task" in asana


        3. Create lofi wireframe
            - Sketch lofi wireframe on paper
            - Create a google drawing to get input on sketch
                - Add title: "x. *Use Case* - Lofi Sketch - *Section* (CL)"
            - Take a photo and upload it to google drawing doc
            - Add any helpful comments, e.g reasoning for design decisions, specific questions about design
            - Create an "input task" in asana
            - After 24 hr input time has ended, resolve any conversations (use real time chat if need be)
            - When all conversations are resolved, create a Hifi wireframe!
        

        4. Create Hifi wireframe
            - Create Hifi wireframe using Adobe XD
            - Inside folder created in step 1, create a google drawing to get input on wireframe
                - Add title: "x. *Use Case* - Hifi wireframe - *Section* (CL)"
            - Export any screens and upload them to google drawing doc
            - Add any helpful comments, e.g reasoning for design decisions, specific questions about design
            - Create an "input task" in asana
            - After 24 hr input time has ended, resolve any conversations (use real time chat if need be)
            - When all conversations are resolved, Create User flow doc!

        5. Create User flow doc
            - create a google drawing file inside use case folder
              - Add title: "x. *Use Case* - User flow - *Section* (CL)"
            - Combine action steps with wireframes in file
            - Create an "input task" in asana
            - After 24 hr input time has ended, resolve any conversations (use real time chat if need be)


        -   See: [User flow is the new wireframe](https://uxdesign.cc/when-to-use-user-flows-guide-8b26ca9aa36a) & [The How (and Why) of User Flows](https://uxdesign.cc/the-how-and-why-of-user-flows-85df776a1e2) 

    -   A Sequence Diagram ([tutorial](https://creately.com/blog/diagrams/sequence-diagram-tutorial/), examples: [oauth2](https://developers.google.com/identity/protocols/oauth2?csw=1))  

        -   "x. *Use Case* < Sequence Diagram < *Section* (CL)"

        -   See [Sequence Diagram Legend](https://docs.google.com/drawings/d/1KHo0M8I2elC-vrY2kQYZ38CgU4O2P9hkD4BFeoDcxSY/edit) 

        -   Decide on widget/action/middleware names

-   An issue on GitHub for each use case:

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