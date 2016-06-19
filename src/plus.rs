use libc::c_char;
use std::ffi::{CStr, CString};
use std::str;
use std::path::Path;

#[no_mangle]
pub extern "C" fn plus(s1: *const c_char, s2: *const c_char) -> *const c_char {
    let c_str1 = unsafe {
        assert!(!s1.is_null());
        CStr::from_ptr(s1)
    };
    let c_str2 = unsafe {
        assert!(!s2.is_null());
        CStr::from_ptr(s2)
    };

    let r_str1 = str::from_utf8(c_str1.to_bytes()).unwrap_or("");
    let r_str2 = str::from_utf8(c_str2.to_bytes()).unwrap_or("");

    let path = Path::new(r_str1).join(r_str2);
    let path_str = path.to_str().unwrap();

    if r_str2 == ".." || r_str2 == "/" {
        CString::new(r_str2).unwrap().into_raw()
    } else if r_str2 == "." {
        CString::new(r_str1).unwrap().into_raw()
    } else if path_str.ends_with("/") && path_str != "/" {
        let stripped_path_str = path_str.trim_right_matches("/");
        CString::new(stripped_path_str).unwrap().into_raw()
    } else {
        CString::new(path_str).unwrap().into_raw()
    }
}
