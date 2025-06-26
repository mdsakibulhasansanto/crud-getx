class Api {
   final String _baseUrl = 'https://crud.teamrabbil.com/api/v1';

   String get productGetUrl => '$_baseUrl/ReadProduct';
   String get createProduct => '$_baseUrl/CreateProduct';

   String deleteProduct(String id) => '$_baseUrl/DeleteProduct/$id';

   String updateProduct(String id) => '$_baseUrl/UpdateProduct/$id';
}
