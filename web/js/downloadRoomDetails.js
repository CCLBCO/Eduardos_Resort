/* global html2pdf */

const button = document.getElementById('rdPDF');
console.log(button);

window.onload = function () {
    document.getElementById("rdPDF").addEventListener("click",()=>{
        const receipt = this.document.getElementById("container");
        console.log(container);
        console.log(window);
        var opt = {
          margin: 1, 
          filename: 'Eduardos_Receipt.pdf',
          image:  { type: 'pdf', quality: 1 },
          html2canvas: { scale: 2},
          jspDF: { unit: 'in', format: 'letter', orientation: 'landscape' }
        };
        html2pdf().from(receipt).set(opt).save();
    });
};