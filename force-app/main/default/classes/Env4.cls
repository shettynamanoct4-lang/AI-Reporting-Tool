public class Env4 {
    public class Wrapper {
         public Integer statusCode;
         public Boolean success;
         public List<Response> response;
    }
        
        public class Response {
            public Integer id;
            public String title;
            public Integer deductible;
            public Integer policy_max;
            public Integer er_fee;
            public String policy_number;
            public Integer underwriter_id;
            public Integer status_id;
            public Integer has_id_card;
            public String card_url;
            public String card_username;
            public String card_password;
            public String id_card_url;
            public Double price;
            public Integer medical_expenses;
            public Integer emergency_medical_evacuation;
            public Integer emergency_reunion;
            public Integer repatriation;
            public String trip_interuption;
            public String card_template;
            public Integer deductible_type;
            public Integer has_visa_letter;
            public String visa_template;
            public Integer has_trip_can_option;
            public String max_effective_date;
            public String min_effective_date;
            public Integer max_policy_length;
            public Integer annual_max_days;
            public Integer coverage_years_allowed;
            public Integer backdate_length;
            public String group_id;
            public String primary_zone_id;
            public String isi_zone_id;
            public Double nonUSA_price;
            public String plan_updated_date;
            public String plan_created_date;
            public Integer plan_updated_by;
            public Integer plan_created_by;
            public Integer use_brochure_link;
            public String min_age;
            public String max_age;
            public String coverage_start_template;
            public String renewal_template;
            public Integer us_restriction;
            public String school_name;
            public Integer isStudentGroup;
            public Integer brand;
            public Opt_mentalhealth opt_mentalhealth;
            public Opt_mentalhealth opt_telehealth;
            public Integer personal_liability;
            public Integer apple_wallet_enabled;
            public Integer flag_backdated_pax;
            public String certificate_sequence;
            public String group_number;
            public String extends_to_id;
            public String urgent_care_deductible;
            public Integer network_id;
            public String rx_group_number;
            public String rx_bin;
            public String rx_pcn;
        }
        
       
        
        public class Opt_mentalhealth {
            public String name;
            public Integer value;
        }
    
    
    
}