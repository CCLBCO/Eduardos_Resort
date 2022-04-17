const button = document.getElementById('downPDF');
console.log(button);

window.onload = function () {
    document.getElementById("downPDF").addEventListener("click",()=>{
        const receipt = this.document.getElementById("order");
        console.log(order);
        console.log(window);
        var opt = {
          margin: 1, 
          filename: 'Eduardos_Receipt.pdf',
          image:  { type: 'pdf', quality: 0.98 },
          html2canvas: { scale: 1},
          jspDF: { unit: 'in', format: 'a4', orientation:'landscape' }
        };
        html2pdf().from(receipt).set(opt).save();
    });
};