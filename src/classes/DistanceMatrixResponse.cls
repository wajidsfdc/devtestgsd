public class DistanceMatrixResponse {

    public List<String> destination_addresses;
    public List<String> origin_addresses;
    public List<Rows> rows;
    public String status;

    public class Elements {
        public Distance distance;
        public Distance duration;
        public String status;
    }

    public class Distance {
        public String text;
        public Integer value;
    }

    public class Rows {
        public List<Elements> elements;
    }

    
    public static DistanceMatrixResponse parse(String json) {
        return (DistanceMatrixResponse) System.JSON.deserialize(json, DistanceMatrixResponse.class);
    }
}