require 'erb'

module QME

  module Randomizer

    # Provides functionality for randomizing patient records based on erb templates
    class Patient

      # Utility class used to supply a binding to Erb
      class Context

        # Create a new context
        def initialize()
          @genders = ['M', 'F']
          # 300 most popular forenames according to US census 1990
          @forenames = {
            'M' => %w{James John Robert Michael William David Richard Charles Joseph Thomas Christopher Daniel Paul Mark Donald George Kenneth Steven Edward Brian Ronald Anthony Kevin Jason Matthew Gary Timothy Jose Larry Jeffrey Frank Scott Eric Stephen Andrew Raymond Gregory Joshua Jerry Dennis Walter Patrick Peter Harold Douglas Henry Carl Arthur Ryan Roger Joe Juan Jack Albert Jonathan Justin Terry Gerald Keith Samuel Willie Ralph Lawrence Nicholas Roy Benjamin Bruce Brandon Adam Harry Fred Wayne Billy Steve Louis Jeremy Aaron Randy Howard Eugene Carlos Russell Bobby Victor Martin Ernest Phillip Todd Jesse Craig Alan Shawn Clarence Sean Philip Chris Johnny Earl Jimmy Antonio Danny Bryan Tony Luis Mike Stanley Leonard Nathan Dale Manuel Rodney Curtis Norman Allen Marvin Vincent Glenn Jeffery Travis Jeff Chad Jacob Lee Melvin Alfred Kyle Francis Bradley Jesus Herbert Frederick Ray Joel Edwin Don Eddie Ricky Troy Randall Barry Alexander Bernard Mario Leroy Francisco Marcus Micheal Theodore Clifford Miguel Oscar Jay Jim Tom Calvin Alex Jon Ronnie Bill Lloyd Tommy Leon Derek Warren Darrell Jerome Floyd Leo Alvin Tim Wesley Gordon Dean Greg Jorge Dustin Pedro Derrick Dan Lewis Zachary Corey Herman Maurice Vernon Roberto Clyde Glen Hector Shane Ricardo Sam Rick Lester Brent Ramon Charlie Tyler Gilbert Gene Marc Reginald Ruben Brett Angel Nathaniel Rafael Leslie Edgar Milton Raul Ben Chester Cecil Duane Franklin Andre Elmer Brad Gabriel Ron Mitchell Roland Arnold Harvey Jared Adrian Karl Cory Claude Erik Darryl Jamie Neil Jessie Christian Javier Fernando Clinton Ted Mathew Tyrone Darren Lonnie Lance Cody Julio Kelly Kurt Allan Nelson Guy Clayton Hugh Max Dwayne Dwight Armando Felix Jimmie Everett Jordan Ian Wallace Ken Bob Jaime Casey Alfredo Alberto Dave Ivan Johnnie Sidney Byron Julian Isaac Morris Clifton Willard Daryl Ross Virgil Andy Marshall Salvador Perry Kirk Sergio Marion Tracy Seth Kent Terrance Rene Eduardo Terrence Enrique Freddie Wade},
            'F' => %w{Mary Patricia Linda Barbara Elizabeth Jennifer Maria Susan Margaret Dorothy Lisa Nancy Karen Betty Helen Sandra Donna Carol Ruth Sharon Michelle Laura Sarah Kimberly Deborah Jessica Shirley Cynthia Angela Melissa Brenda Amy Anna Rebecca Virginia Kathleen Pamela Martha Debra Amanda Stephanie Carolyn Christine Marie Janet Catherine Frances Ann Joyce Diane Alice Julie Heather Teresa Doris Gloria Evelyn Jean Cheryl Mildred Katherine Joan Ashley Judith Rose Janice Kelly Nicole Judy Christina Kathy Theresa Beverly Denise Tammy Irene Jane Lori Rachel Marilyn Andrea Kathryn Louise Sara Anne Jacqueline Wanda Bonnie Julia Ruby Lois Tina Phyllis Norma Paula Diana Annie Lillian Emily Robin Peggy Crystal Gladys Rita Dawn Connie Florence Tracy Edna Tiffany Carmen Rosa Cindy Grace Wendy Victoria Edith Kim Sherry Sylvia Josephine Thelma Shannon Sheila Ethel Ellen Elaine Marjorie Carrie Charlotte Monica Esther Pauline Emma Juanita Anita Rhonda Hazel Amber Eva Debbie April Leslie Clara Lucille Jamie Joanne Eleanor Valerie Danielle Megan Alicia Suzanne Michele Gail Bertha Darlene Veronica Jill Erin Geraldine Lauren Cathy Joann Lorraine Lynn Sally Regina Erica Beatrice Dolores Bernice Audrey Yvonne Annette June Samantha Marion Dana Stacy Ana Renee Ida Vivian Roberta Holly Brittany Melanie Loretta Yolanda Jeanette Laurie Katie Kristen Vanessa Alma Sue Elsie Beth Jeanne Vicki Carla Tara Rosemary Eileen Terri Gertrude Lucy Tonya Ella Stacey Wilma Gina Kristin Jessie Natalie Agnes Vera Willie Charlene Bessie Delores Melinda Pearl Arlene Maureen Colleen Allison Tamara Joy Georgia Constance Lillie Claudia Jackie Marcia Tanya Nellie Minnie Marlene Heidi Glenda Lydia Viola Courtney Marian Stella Caroline Dora Jo Vickie Mattie Terry Maxine Irma Mabel Marsha Myrtle Lena Christy Deanna Patsy Hilda Gwendolyn Jennie Nora Margie Nina Cassandra Leah Penny Kay Priscilla Naomi Carole Brandy Olga Billie Dianne Tracey Leona Jenny Felicia Sonia Miriam Velma Becky Bobbie Violet Kristina Toni Misty Mae Shelly Daisy Ramona Sherri Erika Katrina Claire}
          }
          # 500 most popular surnames according to US census 1990
          @surnames = %w{Smith Johnson Williams Jones Brown Davis Miller Wilson Moore Taylor Anderson Thomas Jackson White Harris Martin Thompson Garcia Martinez Robinson Clark Rodriguez Lewis Lee Walker Hall Allen Young Hernandez King Wright Lopez Hill Scott Green Adams Baker Gonzalez Nelson Carter Mitchell Perez Roberts Turner Phillips Campbell Parker Evans Edwards Collins Stewart Sanchez Morris Rogers Reed Cook Morgan Bell Murphy Bailey Rivera Cooper Richardson Cox Howard Ward Torres Peterson Gray Ramirez James Watson Brooks Kelly Sanders Price Bennett Wood Barnes Ross Henderson Coleman Jenkins Perry Powell Long Patterson Hughes Flores Washington Butler Simmons Foster Gonzales Bryant Alexander Russell Griffin Diaz Hayes Myers Ford Hamilton Graham Sullivan Wallace Woods Cole West Jordan Owens Reynolds Fisher Ellis Harrison Gibson Mcdonald Cruz Marshall Ortiz Gomez Murray Freeman Wells Webb Simpson Stevens Tucker Porter Hunter Hicks Crawford Henry Boyd Mason Morales Kennedy Warren Dixon Ramos Reyes Burns Gordon Shaw Holmes Rice Robertson Hunt Black Daniels Palmer Mills Nichols Grant Knight Ferguson Rose Stone Hawkins Dunn Perkins Hudson Spencer Gardner Stephens Payne Pierce Berry Matthews Arnold Wagner Willis Ray Watkins Olson Carroll Duncan Snyder Hart Cunningham Bradley Lane Andrews Ruiz Harper Fox Riley Armstrong Carpenter Weaver Greene Lawrence Elliott Chavez Sims Austin Peters Kelley Franklin Lawson Fields Gutierrez Ryan Schmidt Carr Vasquez Castillo Wheeler Chapman Oliver Montgomery Richards Williamson Johnston Banks Meyer Bishop Mccoy Howell Alvarez Morrison Hansen Fernandez Garza Harvey Little Burton Stanley Nguyen George Jacobs Reid Kim Fuller Lynch Dean Gilbert Garrett Romero Welch Larson Frazier Burke Hanson Day Mendoza Moreno Bowman Medina Fowler Brewer Hoffman Carlson Silva Pearson Holland Douglas Fleming Jensen Vargas Byrd Davidson Hopkins May Terry Herrera Wade Soto Walters Curtis Neal Caldwell Lowe Jennings Barnett Graves Jimenez Horton Shelton Barrett Obrien Castro Sutton Gregory Mckinney Lucas Miles Craig Rodriquez Chambers Holt Lambert Fletcher Watts Bates Hale Rhodes Pena Beck Newman Haynes Mcdaniel Mendez Bush Vaughn Parks Dawson Santiago Norris Hardy Love Steele Curry Powers Schultz Barker Guzman Page Munoz Ball Keller Chandler Weber Leonard Walsh Lyons Ramsey Wolfe Schneider Mullins Benson Sharp Bowen Daniel Barber Cummings Hines Baldwin Griffith Valdez Hubbard Salazar Reeves Warner Stevenson Burgess Santos Tate Cross Garner Mann Mack Moss Thornton Dennis Mcgee Farmer Delgado Aguilar Vega Glover Manning Cohen Harmon Rodgers Robbins Newton Todd Blair Higgins Ingram Reese Cannon Strickland Townsend Potter Goodwin Walton Rowe Hampton Ortega Patton Swanson Joseph Francis Goodman Maldonado Yates Becker Erickson Hodges Rios Conner Adkins Webster Norman Malone Hammond Flowers Cobb Moody Quinn Blake Maxwell Pope Floyd Osborne Paul Mccarthy Guerrero Lindsey Estrada Sandoval Gibbs Tyler Gross Fitzgerald Stokes Doyle Sherman Saunders Wise Colon Gill Alvarado Greer Padilla Simon Waters Nunez Ballard Schwartz Mcbride Houston Christensen Klein Pratt Briggs Parsons Mclaughlin Zimmerman French Buchanan Moran Copeland Roy Pittman Brady Mccormick Holloway Brock Poole Frank Logan Owen Bass Marsh Drake Wong Jefferson Park Morton Abbott Sparks Patrick Norton Huff Clayton Massey Lloyd Figueroa Carson Bowers Roberson Barton Tran Lamb Harrington Casey Boone Cortez Clarke Mathis Singleton Wilkins Cain Bryan Underwood Hogan Mckenzie Collier Luna Phelps Mcguire Allison Bridges Wilkerson Nash Summers Atkins}
          
          @streetnames = %w{Park Main Oak Pine Maple Cedar Elm Lake Hill Second Washington}
          @zipcodes = {
            '01000' => {'city' => 'Springfield', 'state'=> 'MA'},
            '01200' => {'city' => 'Springfield', 'state'=> 'MA'},
            '01400' => {'city' => 'Worcester', 'state'=> 'MA'},
            '02000' => {'city' => 'Brockton', 'state'=> 'MA'},
            '02100' => {'city' => 'Boston', 'state'=> 'MA'},
            '02500' => {'city' => 'Cape Cod', 'state'=> 'MA'},
            '03000' => {'city' => 'Manchester', 'state'=> 'NH'},
            '03300' => {'city' => 'Concord', 'state'=> 'NH'},
            '03500' => {'city' => 'White River Junction', 'state'=> 'VT'},
            '03800' => {'city' => 'Portsmouth', 'state'=> 'NH'},
            '04000' => {'city' => 'Portland', 'state'=> 'ME'},
            '04400' => {'city' => 'Bangor', 'state'=> 'ME'},
            '05400' => {'city' => 'Burlington', 'state'=> 'VT'},
            '06000' => {'city' => 'Hartford', 'state'=> 'CT'},
            '06500' => {'city' => 'New Haven', 'state'=> 'CT'}
          }
        end

        # Pick a gender at random
        # @return 'M' or 'F'
        def gender
          @genders[rand(@genders.length)]
        end
        
        # Picks a race based on 2010 census estimates
        # Pacific Islander 0.2%
        # American Indian 0.9%
        # Asian 4.8%
        # Black persons 12.6%
        # Hispanic 16.3%
        # White 63.7%
        def race_and_ethnicity
          race_percent = rand(999)
          case race_percent
          when 0..1
           # pacific islander
           {race: '2076-8', ethnicity: '2186-5'}
          when 2..10
           # american indian
           {race: '1002-5', ethnicity: '2186-5'}
          when 11..58
           # asian
           {race: '2028-9', ethnicity: '2186-5'}
          when 59..184
           # black
           {race: '2054-5', ethnicity: '2186-5'}
          when 185..347
           # hispanic
           {race: '2106-3', ethnicity: '2135-2'}
          when 348..984
           # white (not hispanic)
           {race: '2106-3', ethnicity: '2186-5'}
          when 985..999
           # other
            {race: '2131-1', ethnicity: '2186-5'}
          end
        end
        
        # Picks spoken language based on 2010 census estamates
        # 80.3% english
        # 12.3% spanish
        # 00.9% chinese
        # 00.7% french
        # 00.4% german
        # 00.4% korean
        # 00.4% vietnamese
        # 00.3% italian
        # 00.3% portuguese
        # 00.3% russian
        # 00.2% japanese
        # 00.2% polish
        # 00.1% greek
        # 00.1% persian
        # 00.1% us sign
        # 03.0% other
        # 
        def language
          language_percent = rand(999)
          case language_percent
          when 0..802
            # english
            'en-US'
          when 802..925
            # spanish
            'es-US'
          when 926..932
            # french
            'fr-US'
          when 933..935
            # italian
            'it-US'
          when 936..938
            # portuguese
            'pt-US'
          when 939..942
            # german
            'de-US'
          when 943..943
            # greek
            'el-US'
          when 944..946
            # russian
            'ru-US'
          when 947..948
            # polish
            'pl-US'
          when 949..949
            # persian
            'fa-US'
          when 950..958
            # chinese
            'zh-US'
          when 959..960
            # japanese
            'ja-US'
          when 961..964
            # korean
            'ko-US'
          when 965..968
            # vietnamese
            'vi-US'
          when 969..969
            # us sign
            'sgn-US'
          when 970..999
            # other
            other = ["aa","ab","ae","af","ak","am","an","ar","as","av","ay","az","ba","be","bg","bh","bi","bm","bn","bo","br","bs","ca","ce","ch","co","cr","cs","cu","cv","cy","da",
                     "dv","dz","ee","eo","et","eu","ff","fi","fj","fo","fy","ga","gd","gl","gn","gu","gv","ha","he","hi","ho","hr","ht","hu","hy","hz","ia","id","ie","ig","ii","ik",
                     "io","is","iu","jv","ka","kg","ki","kj","kk","kl","km","kn","kr","ks","ku","kv","kw","ky","la","lb","lg","li","ln","lo","lt","lu","lv","mg","mh","mi","mk","ml",
                     "mn","mr","ms","mt","my","na","nb","nd","ne","ng","nl","nn","no","nr","nv","ny","oc","oj","om","or","os","pa","pi","ps","qu","rm","rn","ro","rw","sa","sc","sd",
                     "se","sg","si","sk","sl","sm","sn","so","sq","sr","ss","st","su","sv","sw","ta","te","tg","th","ti","tk","tl","tn","to","tr","ts","tt","tw","ty","ug","uk","ur",
                     "uz","ve","vo","wa","wo","xh","yi","yo","za","zu"].sample
            "#{other}-US"
          end
        end

        # Pick a forename at random appropriate for the supplied gender
        # @param [String] gender the gender 'M' or 'F'
        # @return a suitable forename
        def forename(gender)
          @forenames[gender][rand(@forenames[gender].length)]
        end

        # Pick a surname at random
        # @return a surname
        def surname
          @surnames[rand(@surnames.length)]
        end
        
        # Create an address at random
        # @return an address hash
        def address
          zip = @zipcodes.keys[rand(@zipcodes.length)]
          {
            'street' => [
              "#{rand(100)} #{@streetnames[rand(@streetnames.length)]} Street"
            ],
            'city' => @zipcodes[zip]['city'],
            'state' => @zipcodes[zip]['state'],
            'postalCode' => zip
          }.to_json
        end

        # Pick a patient id, which will be a 10 character string, limited to numeric
        # values for the string
        def patient_id
          (0...10).map{ ('0'..'9').to_a[rand(10)] }.join.to_s
        end

        # Return a set of randomly selected numbers between two bounds
        # @param [int] min the lower inclusive bound
        # @param [int] max the upper inclusive bound
        # @param [int] least the minimum count to return
        # @param [int] most the maximum count to return
        # @return [String] a JSON format array of numbers
        def n_between(min, max, least=1, most=1)
          count = least+rand(1+most-least).to_i
          result = []
          count.times do
            result << between(min, max)
          end
          result.to_json
        end

        # Return a randomly selected number between two bounds
        # @param [int] min the lower inclusive bound
        # @param [int] max the upper inclusive bound
        # @return [int] a JSON format array of numbers
        def between(min, max)
          span = max.to_i - min.to_i + 1
          min.to_i+rand(span)
        end

        # Pick true or false according to the supplied probability
        # @param [int] probability the probability of getting true as a percentage
        # @return [boolean] true or false
        def percent(probability)
          return rand(100)<probability
        end

        # Get a binding that for the current instance
        # @return [Binding]
        def get_binding
          binding
        end
      end

      # Create a new instance with the supplied template
      # @param [String] patient the patient template
      def initialize(patient)
        @template = ERB.new(patient)
      end

      # Get a randomized record based on the stored template
      # @return [String] a randomized patient
      def get
        context = Context.new()
        @template.result(context.get_binding)
      end

    end

  end

end