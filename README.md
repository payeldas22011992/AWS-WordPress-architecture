# AWS-WordPress-architecture
AWS WordPress architecture with Terraform, A sample Python code, A sample Ansible playbook, A sample Jenkins pipeline
##################################################################################################################
Architecture: 

                                      +--------------------+
                                      |   End Users        |
                                      +--------------------+
                                                |
                                                | Latency-based Routing
                                                |
                                      +---------+----------+
                                      |    AWS Route 53    |
                                      | (Latency-based DNS)|
                                      +--------------------+
                                                |
              +---------------------------------+---------------------------------+
              |                                 |                                 |
              |                                 |                                 |
    +--------------------+              +--------------------+            +--------------------+
    | AWS CloudFront     |              | AWS CloudFront     |            | AWS CloudFront     |
    |(Global CDN,WAF Geo-Restrictions) (Global CDN,WAF Geo-Restrictions) (Global CDN, WAF for Geo-Restrictions) 
    +--------------------+              +--------------------+            +--------------------+
              |                                 |                                 |
              | Request to nearest Edge Location|                                 |
              |                                 |                                 |
    +--------------------+            +----------------------+            +--------------------------------+
    | EU (Ireland) Region|            | AP (Singapore) Region|            | Other Regions (|ia CloudFront) |
    +--------------------+            +----------------------+            +--------------------------------+
              |                                 |
              |                                 |
              |                                 |
    +--------------------------------+  +--------------------------------+
    | Application Load Balancer (ALB)|  | Application Load Balancer (ALB)|
    |        (in EU-Ireland)         |  |        (in AP-Singapore)       |
    +--------------------------------+  +--------------------------------+
              |                                 |
              |                                 |
              |                                 |
    +------------------------------+  +------------------------------+
    | Auto Scaling Group (ASG)     |  | Auto Scaling Group (ASG)     |
    |  (WordPress EC2 instances)   |  |  (WordPress EC2 instances)   |
    | (Multi-AZ in EU-Ireland)     |  | (Multi-AZ in AP-Singapore)   |
    +------------------------------+  +------------------------------+
              |                                |           
              |                                |           
              |                                |           
    +-------------------+           +-------------------+
    | Amazon EFS        |           | Amazon EFS        |
    | (Shared WP Files) |           | (Shared WP Files) |
    +-------------------+           +-------------------+
              |                                 |
              | Shared File System              | Shared File System
              |                                 |
    +----------------------------------------------------------------+
    | Amazon RDS (MySQL/Aurora) - Multi-AZ Primary (e.g., EU-Ireland)|
    |           with Cross-Region Read Replica (e.g., AP-Singapore)  |
    +----------------------------------------------------------------+
              |
              |
    +--------------------+
    | Amazon S3          |
    | (Media Storage)    |
    +--------------------+

##########################################################################################################################
Component/service descriptions:

•	Amazon VPC: Securely isolates network resources and provides control over IP address ranges, subnets, route tables, and network gateways.
•	Amazon EC2 & Auto Scaling: EC2 instances host WordPress. Auto Scaling groups dynamically adjust the number of instances based on traffic, ensuring performance and cost efficiency.
•	Elastic Load Balancing (ALB): Distributes incoming application traffic across multiple EC2 instances, improving application availability and fault tolerance.
•	Amazon CloudFront: A Content Delivery Network (CDN) that caches content at edge locations globally, reducing latency and acting as the first line of defence for geo-restrictions and DDoS protection.
•	AWS WAF: A web application firewall that protects against common web exploits and allows fine-grained control over traffic, including geo-blocking based on IP address location.
•	Amazon RDS (MySQL): A fully managed relational database service. For high availability, configure a Multi AZ deployment (synchronous replication to a standby instance in another AZ). For cross-region read scaling, use RDS Read Replicas.
•	Amazon S3: Highly durable and scalable object storage for static assets like images, videos, CSS, and JavaScript files.
•	Amazon EFS: A scalable and fully managed Network File System (NFS) for shared storage of WordPress files across multiple EC2 instances within a region.
•	Amazon Route 53: A highly available and scalable cloud DNS web service that includes latency-based routing to direct users to the closest regional endpoint. 
###########################################################################################################################
