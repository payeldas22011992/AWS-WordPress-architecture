output "alb_dns_names" {
         description = "ALB DNS names for all regions"
         value = {
           eu_ireland    = module.eu_ireland.alb_dns
           ap_singapore  = module.ap_singapore.alb_dns
         }
}