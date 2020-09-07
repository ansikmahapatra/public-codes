install.packages("diagram")
library(diagram)

# Create an empty plot
openplotmat()

# Create the co-ordinates
pos <- coordinates(c(1,3,3,3,3))

segmentarrow (from = pos[1, ], to = pos[2, ], dd = 0.45)
straightarrow(from = pos[2, ], to = pos[3, ])
straightarrow(from = pos[3, ], to = pos[4, ])
straightarrow(from = pos[7, ], to = pos[6, ])
straightarrow(from = pos[6, ], to = pos[5, ])
straightarrow(from = pos[10, ], to = pos[9, ])
straightarrow(from = pos[9, ], to = pos[8, ])
straightarrow(from = pos[13, ], to = pos[12, ])
straightarrow(from = pos[12, ], to = pos[11, ])

# the path parameter was used to change the direction
# arr.pos was used to position the arrow
# arr.side was used to specific where the arrow should be drawn

segmentarrow (from = pos[4, ], to = pos[7, ], dd = 0.15, path = 'RVL', arr.pos = 0.24, arr.side = 3)
segmentarrow (from = pos[4, ], to = pos[10, ], dd = 0.15, path = 'RVL', arr.pos = 0.24, arr.side = 3)
segmentarrow (from = pos[4, ], to = pos[13, ], dd = 0.15, path = 'RVL', arr.pos = 0.24, arr.side = 3)

my_label <- c(1, 2, 3, 4, 7, 6, 5, 10, 9, 8, 13, 12, 11)
my_text_size <- 1.3
my_edge_length <- 0.08
for(i in 1:length(my_label)){
  if (i %in% 5:7){
    textrect(mid = pos[i,], radx = my_edge_length, rady = my_edge_length, lab = my_label[i], cex = my_text_size, box.col = "#0072B2")
  } else if (i %in% 8:10){
    textrect(mid = pos[i,], radx = my_edge_length, rady = my_edge_length, lab = my_label[i], cex = my_text_size, box.col = "#009E73")
  } else if (i %in% 11:13){
    textrect(mid = pos[i,], radx = my_edge_length, rady = my_edge_length, lab = my_label[i], cex = my_text_size, box.col = "#D55E00")
  } else {
    textrect(mid = pos[i,], radx = my_edge_length, rady = my_edge_length, lab = my_label[i], cex = my_text_size, box.col = "#999999")
  }
}


install.packages("DiagrammeR")
library(DiagrammeR)

# Types of files supported: .dot, .mmd, .gv

# A minimal plot
grViz("digraph {
                  graph[layout = dot, rankdir = LR]

                  a
                  b
                  c

                  a -> b -> c
                  }")

box1 [fillcolor = red]
abc -> def [arrowhead = diamond]

grViz("digraph {

      graph [layout = dot, rankdir = LR]

      # define the global styles of the nodes. We can override these in box if we wish
      node [shape = rectangle, style = filled, fillcolor = Linen]

      data1 [label = 'Dataset 1', shape = folder, fillcolor = Beige]
      data2 [label = 'Dataset 2', shape = folder, fillcolor = Beige]
      process [label =  'Process \n Data']
      statistical [label = 'Statistical \n Analysis']
      results [label= 'Results']

      # edge definitions with the node IDs
      {data1 data2}  -> process -> statistical -> results
      }")

# Define some sample data
data <- list(a=1000, b=800, c=600, d=400)


grViz("digraph graph2 {

                  graph [layout = dot]

                  # node definitions with substituted label text
                  node [shape = rectangle, width = 4, fillcolor = Biege]
                  a [label = '@@1']
                  b [label = '@@2']
                  c [label = '@@3']
                  d [label = '@@4']

                  a -> b -> c -> d

                  }

                  [1]: paste0('Raw Data (n = ', data$a, ')')
                  [2]: paste0('Remove Errors (n = ', data$b, ')')
                  [3]: paste0('Identify Potential Customers (n = ', data$c, ')')
                  [4]: paste0('Select Top Priorities (n = ', data$d, ')')
                  ")


                  grViz("
                  digraph a_nice_graph {

                  # node definitions with substituted label text
                  node [fontname = Helvetica]
                  a [label = '@@1']
                  b [label = '@@2-1']
                  c [label = '@@2-2']
                  d [label = '@@2-3']
                  e [label = '@@2-4']
                  f [label = '@@2-5']
                  g [label = '@@2-6']
                  h [label = '@@2-7']
                  i [label = '@@2-8']
                  j [label = '@@2-9']

                  # edge definitions with the node IDs
                  a -> {b c d e f g h i j}
                  }

                  [1]: 'top'
                  [2]: 10:20
                  ")


                  grViz("
                  digraph nicegraph {

                    # graph, node, and edge definitions
                    graph [compound = true, nodesep = .5, ranksep = .25,
                           color = crimson]

                    node [fontname = Helvetica, fontcolor = darkslategray,
                          shape = rectangle, fixedsize = true, width = 1,
                          color = darkslategray]

                    edge [color = grey, arrowhead = none, arrowtail = none]

                    # subgraph for R information
                    subgraph cluster0 {
                      node [fixedsize = true, width = 3]
                      '@@1-1' -> '@@1-2' -> '@@1-3' -> '@@1-4'
                      '@@1-4' -> '@@1-5' -> '@@1-6' -> '@@1-7'
                    }

                    # subgraph for RStudio information
                    subgraph cluster1 {
                      node [fixedsize = true, width = 3]
                      '@@2' -> '@@3'
                    }

                    Information             [width = 1.5]
                    Information -> R
                    Information -> RStudio
                    R -> '@@1-1'            [lhead = cluster0]
                    RStudio -> '@@2'        [lhead = cluster1]

                  }

                  [1]: paste0(names(R.Version())[1:7], ':\\n ', R.Version()[1:7])
                  [2]: paste0('RStudio version:\\n ', rstudioapi::versionInfo()[[1]])
                  [3]: paste0('Current program mode:\\n ', rstudioapi::versionInfo()[[2]])

                  ")


                  grViz("
                  digraph dot {

                  graph [layout = dot]

                  node [shape = circle,
                        style = filled,
                        color = grey,
                        label = '']

                  node [fillcolor = red]
                  a

                  node [fillcolor = green]
                  b c d

                  node [fillcolor = orange]

                  edge [color = grey]
                  a -> {b c d}
                  b -> {e f g h i j}
                  c -> {k l m n o p}
                  d -> {q r s t u v}
                  }")

                  grViz("
                  digraph dot {

                  graph [layout = dot,
                         rankdir = LR]

                  node [shape = circle,
                        style = filled,
                        color = grey,
                        label = '']

                  node [fillcolor = red]
                  a

                  node [fillcolor = green]
                  b c d

                  node [fillcolor = orange]

                  edge [color = grey]
                  a -> {b c d}
                  b -> {e f g h i j}
                  c -> {k l m n o p}
                  d -> {q r s t u v}
                  }")


                  grViz("
                  digraph neato {

                  graph [layout = neato]

                  node [shape = circle,
                        style = filled,
                        color = grey,
                        label = '']

                  node [fillcolor = red]
                  a

                  node [fillcolor = green]
                  b c d

                  node [fillcolor = orange]

                  edge [color = grey]
                  a -> {b c d}
                  b -> {e f g h i j}
                  c -> {k l m n o p}
                  d -> {q r s t u v}
                  }")

                  grViz("
                  digraph twopi {

                  graph [layout = twopi]

                  node [shape = circle,
                        style = filled,
                        color = grey,
                        label = '']

                  node [fillcolor = red]
                  a

                  node [fillcolor = green]
                  b c d

                  node [fillcolor = orange]

                  edge [color = grey]
                  a -> {b c d}
                  b -> {e f g h i j}
                  c -> {k l m n o p}
                  d -> {q r s t u v}
                  }")


                  grViz("
                  digraph circo {

                  graph [layout = circo]

                  node [shape = circle,
                        style = filled,
                        color = grey,
                        label = '']

                  node [fillcolor = red]
                  a

                  node [fillcolor = green]
                  b c d

                  node [fillcolor = orange]

                  edge [color = grey]
                  a -> {b c d}
                  b -> {e f g h i j}
                  c -> {k l m n o p}
                  d -> {q r s t u v}
                  }")

mermaid("
graph LR
  A-->B
  A-->C
  C-->E
  B-->D
  C-->D
  D-->F
  E-->F
")

mermaid("
graph TB
  A-->B
  A-->C
  C-->E
  B-->D
  C-->D
  D-->F
  E-->F
")

# For more info: https://rich-iannone.github.io/DiagrammeR/graphviz_and_mermaid.html

# Sequence DiagrammeR

mermaid("
sequenceDiagram
        User Mobility App->>HELIX Mobile App: Deep Link Request
        HELIX Mobile App->>HELIX Mobile App: processID
        HELIX Mobile App->>HELIX Mobile App: Splash Screen
        HELIX Mobile App->>HELIX MW App Server: Apply Credential Confirmation
        HELIX MW App Server->>HELIX MW App Server: CouchDb
        alt User Exists/ Credentials Match/ App Exists: True
          HELIX MW App Server->>HELIX Mobile App: Status '2' Credential Criteria Confirmed
          HELIX Mobile App->>HELIX Mobile App: Hello username Screen
        else False
          HELIX Mobile App->>HELIX Mobile App: Load Fail Screen
          HELIX Mobile App->>User Mobility App: Deep Link Status '0/1'
        end
        alt User Confirm
          HELIX Mobile App->>HELIX MW App Server: User clicks Apply/ Ready to create Claim
          HELIX MW App Server->>HELIX MW App Server: Create and persist business process Pseudonym
          HELIX MW App Server->>HELIX Mobile App: Confirm AccountID, Path, Pseudonym
          HELIX Mobile App->>User Mobility App: Deep Link + Return Claim Parameters
          HELIX MW App Server->>HELIX MW Claim Mgmt: Create Claim Request
          HELIX MW Claim Mgmt->> HELIX Claim Service: Set Claim
          HELIX Claim Serive->>HELIX MW Claim Mgmt: Return Value
          HELIX MW Claim Mgmt->>HELIX MW App Server: Ack Claim Exists
          HELIX MW App Server->>HELIX MW App Server: Set Ack Flag
        else User Reject
          HELIX Mobile App->>User Mobility App: Deep Link Status '1'
        end
        User Mobility App->>Fleet Node: Pseudonym, AccountID, Path
        Fleet Node->>HELIX Claim Service: Get Verification
        HELIX Claim Service->>Fleet Node: Acknowledge Verification
        Fleet Node->>User Mobility App: Confirm Contract Details
        User Mobility App->>HELIX Mobile App: Request Type Signature - Contract Details
        HELIX Mobile App->>HELIX Mobile App: Signature Screen showing contract details
        alt User Confirm
          HELIX Mobile App->>User Mobility App: Deep Link Status 4
        else User Reject
          HELIX Mobile App->>User Mobility App: Deep Link Status 3
        end
        ")
