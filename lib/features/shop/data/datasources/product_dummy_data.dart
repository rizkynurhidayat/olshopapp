import '../models/product_model.dart';

class ProductDummyData {
  static const List<ProductModel> products = [
    ProductModel(
      id: 1,
      title: "Premium Leather Jacket",
      price: 12.999,
      description: "A high-quality leather jacket that keeps you warm and stylish. Made from genuine cowhide leather.",
      category: "Men's Clothing",
      image: "https://images.unsplash.com/photo-1521223890158-f9f7c3d5d504?q=80&w=300&h=400&fit=crop",
    ),
    ProductModel(
      id: 2,
      title: "Modern Minimalist Watch",
      price: 85.999,
      description: "Elegant and simple design for every occasion. Waterproof and durable.",
      category: "Accessories",
      image: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=300&h=400&fit=crop",
    ),
    ProductModel(
      id: 3,
      title: "Pro Wireless Headphones",
      price: 19.999,
      description: "Noise-cancelling wireless headphones with 40 hours of battery life and studio-quality sound.",
      category: "Electronics",
      image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=300&h=400&fit=crop",
    ),
    ProductModel(
      id: 4,
      title: "Running Sneakers X1",
      price: 95.999,
      description: "Lightweight and breathable sneakers designed for long-distance running and maximum comfort.",
      category: "Shoes",
      image: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=300&h=400&fit=crop",
    ),
    ProductModel(
      id: 5,
      title: "Organic Cotton T-Shirt",
      price: 25.999,
      description: "Soft and breathable t-shirt made from 100% organic cotton. Eco-friendly and comfortable.",
      category: "Men's Clothing",
      image: "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?q=80&w=300&h=400&fit=crop",
    ),
    ProductModel(
      id: 6,
      title: "Smart Ergonomic Desk",
      price: 450.999,
      description: "Adjustable height desk to improve your productivity and health while working from home.",
      category: "Furniture",
      image: "https://images.unsplash.com/photo-1518455027359-f3f816b1a22a?q=80&w=300&h=400&fit=crop",
    ),
  ];
}
