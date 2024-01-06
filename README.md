# WeatherForeCasts
<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/1fee10ee-da23-470d-be56-34955d055d9b" width="100">

### WeatherForeCasts là một ứng dụng thời tiết tiện ích và đa chức năng, giúp bạn nhanh chóng cập nhật thông tin thời tiết hiện tại và dự báo trong tương lai trên toàn cầu, mang đến trải nghiệm đơn giản, dễ sử dụng và chính xác để giúp bạn chuẩn bị tốt hơn cho mọi loại thời tiết.
# Tóm tắt cách hoạt động của ứng dụng :
- Đăng nhập, Đăng kí tài khoản bằng FireBase, tải hình ảnh bằng Kingfisher.
- Sử dụng Alamofire Call API dữ liệu thời tiết từ https://www.weatherapi.com, Tách và xử lí dữ liệu theo thiết kế UI, UX.
- Sử dụng Charts vẽ biểu đồ nhiệt độ.
- Hiển thị thông tin thời tiết bằng UICollectionView, UITableView.
- Lưu trữ một phần dữ liệu với Core Data, tránh load lại data mỗi lần vào màn.
- Sử dụng Core Animation thể hiện quy đạo của măt trăng, mặt trời dựa trên thời gian hiện tại.
- Sử dụng MapKit và searchBar để lấy vị trí và hiển thị vị trí trên màn hình.
- Một số màn hình có nhiều code sẽ sử dụng mô hình MVP, kết hợp extension và Utils giảm bớt số lượng code lặp lại
- Ứng dụng có thể thay đổi theme sáng, tối, mặc định, ngôn ngữ tiếng anh hoặc tiếng việt.

# Màn hình Splash
<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/e3952c56-12ec-43b7-bc16-d75d6c6610ae" width="400">

# Màn hình Onbroading
- Thao tác vuốt màn hình hoặc nhấn nút tiếp theo để chuyển tiếp màn hình

<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/096cd718-fb0c-4bd6-a552-46209863fad5" width="200">&nbsp;
<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/d459d7e2-47bd-40f9-a253-8efbe22e4337" width="200">&nbsp;
<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/b3cc978d-2c42-4071-a13a-34249e958b9f" width="200">

# Màn hình Đăng nhập
- Kiểm tra định dạng email và mật khẩu ngay khi người dùng nhập thông tin,khóa nút "Đăng nhập" tới khi nào thông tin đúng định dạng.
- Nhấn nút đăng khí để chuyển sang màn hình đăng kí tài khoản.
- Tính năng đăng nhập bằng mạng xã hội chưa được thực hiện, vui lòng chờ đợi.
- Nhấn nút quên mật khẩu để chuyển sang màn hình cài lại mật khẩu.

<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/cadb3431-5a5d-4e8c-9eca-2ef2bd983b8c" width="200">&nbsp;
<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/712aca1c-f1e2-4483-bd54-ae28c3502547" width="200">

# Màn hình Đăng kí
- Những thông tin bạn đã nhập ở màn hình "Đăng nhập" sẽ đươc chuyển sang màn hình này.
- Kiểm tra định dạng email và mật khẩu ngay khi người dùng nhập thông tin,khóa nút "Đăng kí" tới khi nào thông tin đúng định dạng.
- Nhấn nút đăng nhập để chuyển sang màn hình đăng nhập tài khoản.
- Tính năng đăng nhập bằng mạng xã hội chưa được thực hiện, vui lòng chờ đợi.
- Nhấn nút quên mật khẩu để chuyển sang màn hình cài lại mật khẩu.

<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/960a679b-a20a-4bce-8923-202a2eb14cbc" width="200">&nbsp;
<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/ad568363-e576-4614-a107-b0a64c69f1dd" width="200">

# Màn hình Quên Mật Khẩu
- Những thông tin bạn đã nhập ở màn hình "Đăng nhập" hoặc "Đăng kí" sẽ đươc chuyển sang màn hình này.
- Kiểm tra định dạng email ngay khi người dùng nhập thông tin,khóa nút "Gửi yêu cầu" tới khi nào thông tin đúng định dạng.
- Mật khẩu mới sẽ được gửi đến email,màn hình sẽ tự động chuyển sang màn hình "Đăng nhập" và điền thông tin email vào ô đăng nhập, người dùng lấy mật khẩu từ email và điền vào ô mật khẩu.

<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/fa94d3f2-86a6-4b6b-aafd-ef3423c01059" width="200">

# Màn hình Home

https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/efa50b40-2a26-4d52-a37d-ec2a335411f6

<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/fb7fe646-c7cf-4e7e-bb3b-e8c0dc85e63b" width="200">&nbsp;
<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/e458f2f5-85c4-4a78-ba0c-7f79c1ee9a74" width="200">&nbsp;
<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/3b7d6a7b-dfa7-46f6-ab9a-3d9759e64d1c" width="200">

- Nhấn vào tên địa điểm để chuyển sang bản đồ chọn địa điểm dự báo
- Nhấn vào nút tọa độ để dự báo thời tiết dựa trên vị trí hiện tại
- Nhấn vào biểu tượng side menu để truy cập thêm các lối tắt khác
- Hiển thị các thônng tin thời tiết 24h.
- Dự báo thời tiết 14 ngày tiết theo. Nhấn vào ô này sẽ chuyển qua màn hình dự báo chi tiết 14 ngày
- Hiển thị các thông tin khác về thời tiết, chu kì mặt trăng và mặt trời, lời khuyên dựa trên các điều kiện thời tiết


# Màn hình Dự báo thời tiết 14 ngày
- Dự báo thời tiết 14 ngày tiết theo. Nhấn vào các ô ngày sẽ hiển thị thông tin thời tiết tương ứng.
- Nhấn vào thông tin thời tiết sẽ hiển thị thời tiết 24h của ngày đó.

<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/9b6f7878-256f-419e-a0a4-50698b075ed8" width="200">&nbsp;
<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/94edc8f7-f9b2-4215-8bd6-3bcee77c4b88" width="200">


# Màn hình Bản Đồ
- Hiển thị bản đồ,khi click vào search bar sẽ hiển thị lịch sử tìm kiếm
- Lưu dữu liệu vị trí, tên địa điểm vào Core Data sau đó gọi lại API

<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/39e13170-1131-43e5-8dfb-99e11b4c1b23" width="200">&nbsp;
<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/7859b5c3-9f31-450f-aed9-cdd23d7de529" width="200">

# Màn hình Thông tin cá nhân
- Nhấn nút sửa thông tin để bắt đầu thay đổi thông tin
- Sau khi cập nhật thông tin, dữ liệu sẽ được lưu vào CoreData và update lên Firebase
- Dữ liệu từ CoreData sẽ được hiển thị trên sideMenu và được sử dụng để load lại khi người dùng truy cập lại màn hình này 

<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/888043ab-592f-4bf8-8eb3-d19e60b5c7c7" width="200">

# Màn hình Cài đặt
- Ban đầu nền và ngôn ngữ sẽ mặc định nữa theo thiết bị
- Sau khi chọn ngôn ngữ cần khởi động lại ứng dụng

<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/a1b30d37-8641-44ab-9281-fd320838d386" width="200">


# Màn hình Kết nối Internet
- Khi bị mất kết nối mạng, người dùng sẽ được chuyển sang màn hình này

<img src="https://github.com/NHuuLinh/WeatherForeCasts/assets/138550906/e6db193e-251e-471b-8b42-ad0dcaaa2c0e" width="200">&nbsp;


# Liên lạc
Xin vui lòng gửi bất cứ phản hồi và nhận xét nào bạn muốn đóng góp tới địa chỉ email : nguyenhuulinhd10codt@gmail.com






